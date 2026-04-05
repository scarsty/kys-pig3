// kys_engine.cpp - 引擎实现
// 对应 kys_engine.pas

#include "kys_engine.h"
#include "kys_type.h"
#include "kys_main.h"
#include "kys_draw.h"

#include <SDL3/SDL.h>
#include <SDL3_ttf/SDL_ttf.h>
#include <SDL3_mixer/SDL_mixer.h>

#include "filefunc.h"
#include "strfunc.h"
#include "PotConv.h"
#include "ZipFile.h"

#include <algorithm>
#define _USE_MATH_DEFINES
#include <cmath>
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif
#include <cstring>
#include <fstream>
#include <map>

// 内部变量
static MIX_Mixer* gMixer = nullptr;
static MIX_Track* MusicTrack = nullptr;
static MIX_Track* SfxTracks[10] = {};
static int SfxNextTrack = 0;

//----------------------------------------------------------------------
// Mixer 辅助
//----------------------------------------------------------------------
static bool EnsureMixerCreated()
{
    if (gMixer != nullptr) return true;
    if (!MIX_Init()) return false;
    SDL_AudioSpec spec;
    spec.freq = 22500;
    spec.format = SDL_AUDIO_S16;
    spec.channels = 2;
    gMixer = MIX_CreateMixerDevice(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec);
    return gMixer != nullptr;
}

static MIX_Track* AcquireSfxTrack(MIX_Audio* audio)
{
    if (audio == nullptr) return nullptr;
    int idx = SfxNextTrack;
    SfxNextTrack++;
    if (SfxNextTrack > 9) SfxNextTrack = 0;
    if (!MIX_SetTrackAudio(SfxTracks[idx], audio)) return nullptr;
    return SfxTracks[idx];
}

//----------------------------------------------------------------------
// EventFilter / EventWatch
//----------------------------------------------------------------------
bool EventFilter(void* p, SDL_Event* e)
{
    switch (e->type)
    {
    case SDL_EVENT_FINGER_UP:
    case SDL_EVENT_FINGER_DOWN:
    case SDL_EVENT_GAMEPAD_AXIS_MOTION:
    case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
    case SDL_EVENT_GAMEPAD_BUTTON_UP:
        return false;
    case SDL_EVENT_FINGER_MOTION:
        if (CellPhone == 0) return false;
        break;
    }
    return true;
}

bool EventWatch(void* p, SDL_Event* e)
{
    switch (e->type)
    {
    case SDL_EVENT_DID_ENTER_FOREGROUND:
        PlayMP3(NowMusic, -1, 0);
        break;
    case SDL_EVENT_DID_ENTER_BACKGROUND:
        StopMP3();
        break;
    }
    return true;
}

void SendKeyEvent(int keyvalue)
{
    SDL_Event e;
    e.type = SDL_EVENT_KEY_UP;
    e.key.key = keyvalue;
    SDL_PushEvent(&e);
}

//----------------------------------------------------------------------
// 音频
//----------------------------------------------------------------------
void InitialMusic()
{
    if (!EnsureMixerCreated()) return;
    if (MusicTrack == nullptr)
        MusicTrack = MIX_CreateTrack(gMixer);
    for (int i = 0; i < 10; i++)
        if (SfxTracks[i] == nullptr)
            SfxTracks[i] = MIX_CreateTrack(gMixer);
    SfxNextTrack = 0;

    for (int i = 0; i < (int)Music.size(); i++)
    {
        if (Music[i] != nullptr) { MIX_DestroyAudio(Music[i]); Music[i] = nullptr; }
        std::string str = AppPath + "music/" + std::to_string(i) + ".mp3";
        if (filefunc::fileExist(str))
            Music[i] = MIX_LoadAudio(nullptr, str.c_str(), false);
        else
        {
            str = AppPath + "music/" + std::to_string(i) + ".mid";
            if (filefunc::fileExist(str))
            {
                SDL_PropertiesID id = SDL_CreateProperties();
                SDL_IOStream* io = SDL_IOFromFile(str.c_str(), "rb");
                SDL_SetPointerProperty(id, MIX_PROP_AUDIO_LOAD_IOSTREAM_POINTER, io);
                SDL_SetStringProperty(id, MIX_PROP_AUDIO_DECODER_STRING, "fluidsynth");
                std::string sf2 = AppPath + "music/mid.sf2";
                SDL_SetStringProperty(id, "SDL_mixer.decoder.fluidsynth.soundfont_path", sf2.c_str());
                Music[i] = MIX_LoadAudioWithProperties(id);
                SDL_CloseIO(io);
                SDL_DestroyProperties(id);
            }
        }
    }

    for (int i = 0; i < (int)ESound.size(); i++)
    {
        if (ESound[i] != nullptr) { MIX_DestroyAudio(ESound[i]); ESound[i] = nullptr; }
        std::string str = AppPath + "sound/e" + std::to_string(i) + ".wav";
        if (filefunc::fileExist(str))
            ESound[i] = MIX_LoadAudio(nullptr, str.c_str(), false);
    }
    for (int i = 0; i < (int)ASound.size(); i++)
    {
        if (ASound[i] != nullptr) { MIX_DestroyAudio(ASound[i]); ASound[i] = nullptr; }
        char buf[64];
        snprintf(buf, sizeof(buf), "sound/atk%02d.wav", i);
        std::string str = AppPath + buf;
        if (filefunc::fileExist(str))
            ASound[i] = MIX_LoadAudio(nullptr, str.c_str(), false);
    }
}

void FreeAllMusic()
{
    if (MusicTrack) { MIX_StopTrack(MusicTrack, 0); MIX_DestroyTrack(MusicTrack); MusicTrack = nullptr; }
    for (int i = 0; i < 10; i++)
        if (SfxTracks[i]) { MIX_StopTrack(SfxTracks[i], 0); MIX_DestroyTrack(SfxTracks[i]); SfxTracks[i] = nullptr; }
    for (auto& m : Music) if (m) { MIX_DestroyAudio(m); m = nullptr; }
    for (auto& s : ASound) if (s) { MIX_DestroyAudio(s); s = nullptr; }
    for (auto& s : ESound) if (s) { MIX_DestroyAudio(s); s = nullptr; }
    if (gMixer) { MIX_DestroyMixer(gMixer); gMixer = nullptr; MIX_Quit(); }
}

void PlayMP3(int MusicNum, int times, int frombeginning)
{
    if (!EnsureMixerCreated()) return;
    if (MusicNum >= 0 && MusicNum < (int)Music.size() && VOLUME > 0)
    {
        if (Music[MusicNum] != nullptr)
        {
            MIX_StopTrack(MusicTrack, 0);
            MIX_SetTrackAudio(MusicTrack, Music[MusicNum]);
            if (frombeginning == 1) MIX_SetTrackPlaybackPosition(MusicTrack, 0);
            MIX_SetTrackGain(MusicTrack, VOLUME / 100.0f);
            MIX_SetTrackLoops(MusicTrack, -1);
            SDL_PropertiesID id = SDL_CreateProperties();
            SDL_SetNumberProperty(id, MIX_PROP_PLAY_FADE_IN_MILLISECONDS_NUMBER, 50);
            SDL_SetNumberProperty(id, MIX_PROP_PLAY_LOOPS_NUMBER, -1);
            MIX_PlayTrack(MusicTrack, id);
            SDL_DestroyProperties(id);
            NowMusic = MusicNum;
        }
    }
}

void PlayMP3(const char* filename, int times) { /* TODO */ }

void StopMP3(int frombeginning)
{
    if (MusicTrack != nullptr)
    {
        MIX_StopTrack(MusicTrack, 0);
        if (frombeginning == 1) MIX_SetTrackPlaybackPosition(MusicTrack, 0);
    }
}

void PlaySound(int SoundNum, int times)
{
    int loops = (times == -1) ? -1 : 0;
    if (SoundNum >= 0 && SoundNum < (int)ESound.size() && VOLUMEWAV > 0)
    {
        if (ESound[SoundNum] != nullptr)
        {
            MIX_Track* track = AcquireSfxTrack(ESound[SoundNum]);
            if (track == nullptr) return;
            MIX_SetTrackGain(track, VOLUMEWAV / 100.0f);
            MIX_SetTrackLoops(track, loops);
            MIX_PlayTrack(track, 0);
        }
    }
}

void PlaySound(int SoundNum, int times, int x, int y, int z)
{
    int loops = (times == -1) ? -1 : 0;
    if (SoundNum >= 0 && SoundNum < (int)ESound.size() && VOLUMEWAV > 0)
    {
        if (ESound[SoundNum] != nullptr)
        {
            MIX_Track* track = AcquireSfxTrack(ESound[SoundNum]);
            if (track == nullptr) return;
            if (SOUND3D == 1)
            {
                MIX_Point3D pos;
                pos.x = (float)(x * 100);
                pos.y = (float)(y * 100);
                pos.z = (float)(z * 100);
                MIX_SetTrack3DPosition(track, &pos);
            }
            MIX_SetTrackGain(track, VOLUMEWAV / 100.0f);
            MIX_SetTrackLoops(track, loops);
            MIX_PlayTrack(track, 0);
        }
    }
}

void PlaySoundA(int SoundNum, int times)
{
    int loops = (times == -1) ? -1 : 0;
    if (SoundNum >= 0 && SoundNum < (int)ASound.size() && VOLUMEWAV > 0)
    {
        if (ASound[SoundNum] != nullptr)
        {
            MIX_Track* track = AcquireSfxTrack(ASound[SoundNum]);
            if (track == nullptr) return;
            MIX_SetTrackGain(track, VOLUMEWAV / 100.0f);
            MIX_SetTrackLoops(track, loops);
            MIX_PlayTrack(track, 0);
        }
    }
}

void PlaySound(int SoundNum) { PlaySound(SoundNum, 0); }
void PlaySound(const char* filename, int times) { /* TODO */ }

//----------------------------------------------------------------------
// 基本绘图
//----------------------------------------------------------------------
void PutPixel(SDL_Surface* surface, int x, int y, uint32 pixel)
{
    if (x >= 0 && x < surface->w && y >= 0 && y < surface->h)
    {
        uint32* p = (uint32*)((uint8_t*)surface->pixels + y * surface->pitch + x * 4);
        *p = pixel;
    }
}

uint32 ColColor(int num)
{
    return MapRGBA(ACol[num * 3] * 4, ACol[num * 3 + 1] * 4, ACol[num * 3 + 2] * 4);
}

bool JudgeInScreen(int px, int py, int w, int h, int xs, int ys) { return true; }
bool JudgeInScreen(int px, int py, int w, int h, int xs, int ys, int xx, int yy, int xw, int yh)
{
    return (px - xs + w >= xx) && (px - xs < xx + xw) && (py - ys + h >= yy) && (py - ys < yy + yh);
}

TPosition GetPositionOnScreen(int x, int y, int cx, int cy)
{
    TPosition r;
    r.x = -(x - cx) * 18 + (y - cy) * 18 + CENTER_X;
    r.y = (x - cx) * 9 + (y - cy) * 9 + CENTER_Y;
    if (needOffset != 0)
    {
        r.x -= offsetX;
        r.y -= offsetY;
    }
    return r;
}

//----------------------------------------------------------------------
// 文字编码
//----------------------------------------------------------------------
std::string Big5ToUnicode(const char* str)
{
    return PotConv::conv(str, "BIG5", "UTF-8");
}

std::string GBKToUnicode(const char* str)
{
    return PotConv::conv(str, "GBK", "UTF-8");
}

std::string UnicodeToGBK(const char* str)
{
    return PotConv::conv(str, "UTF-8", "GBK");
}

bool IsStringUTF8(const std::string& str)
{
    int nBytes = 0;
    bool bAllAscii = true;
    for (size_t i = 0; i < str.size(); i++)
    {
        unsigned char c = (unsigned char)str[i];
        if (c & 0x80) bAllAscii = false;
        if (nBytes == 0)
        {
            if (c >= 0x80)
            {
                if (c >= 0xFC) nBytes = 6;
                else if (c >= 0xF8) nBytes = 5;
                else if (c >= 0xF0) nBytes = 4;
                else if (c >= 0xE0) nBytes = 3;
                else if (c >= 0xC0) nBytes = 2;
                else return false;
                nBytes--;
            }
        }
        else
        {
            if ((c & 0xC0) != 0x80) return false;
            nBytes--;
        }
    }
    if (nBytes > 0) return false;
    return true;
}

std::string Simplified2Traditional(const std::string& str)
{
    // TODO: 使用SimpleCC库进行简繁转�?
    return str;
}

std::string Traditional2Simplified(const std::string& str)
{
    // TODO: 使用SimpleCC库进行繁简转换
    return str;
}

//----------------------------------------------------------------------
// 文字绘制
//----------------------------------------------------------------------
int utf8follow(char c1)
{
    unsigned char c = (unsigned char)c1;
    if (c < 0x80) return 1;
    if (c < 0xC0) return 1;
    if (c < 0xE0) return 2;
    if (c < 0xF0) return 3;
    return 4;
}

void DrawText(const std::string& word, int x_pos, int y_pos, uint32 color, int engwidth)
{
    if (word.empty()) return;
    uint8_t r, g, b;
    GetRGBA(color, &r, &g, &b);

    std::string text = word;
    if (SIMPLE == 1) text = Traditional2Simplified(text.c_str());

    if (engwidth <= 0) engwidth = CHINESE_FONT_REALSIZE / 2;

    SDL_FRect dest;
    dest.x = (float)x_pos;
    dest.y = (float)y_pos;

    size_t i = 0;
    while (i < text.size())
    {
        unsigned char ch = (unsigned char)text[i];
        int k;
        if (ch < 128)
        {
            dest.y = (float)(y_pos + 3);
            k = ch;
            i++;
        }
        else
        {
            dest.y = (float)y_pos;
            int len = utf8follow(text[i]);
            k = (unsigned char)text[i] + (unsigned char)text[i + 1] * 256;
            if (len == 3 && i + 2 < text.size())
                k += (unsigned char)text[i + 2] * 65536;
            i += len;
        }

        // TODO: CreateFontTile 渲染单个字符
        // 简化处�? 直接使用TTF渲染
        if (k >= 128)
            dest.x += CHINESE_FONT_REALSIZE;
        else
            dest.x += engwidth;
    }
    HaveText = 1;
}

void DrawEngText(const std::string& word, int x_pos, int y_pos, uint32 color)
{
    DrawText(word, x_pos, y_pos - 4, color, -1);
}

void DrawShadowText(const std::string& word, int x_pos, int y_pos, uint32 color1, uint32 color2,
    SDL_Texture* Tex, SDL_Surface* Sur, int realPosition, int eng)
{
    SDL_Texture* ptex = nullptr;
    SDL_Surface* pscreen = nullptr;

    if (SW_SURFACE == 0)
    {
        ptex = SDL_GetRenderTarget(render);
        if (Tex == nullptr)
        {
            if (TEXT_LAYER != 0)
                SDL_SetRenderTarget(render, TextScreenTex);
        }
        else
            SDL_SetRenderTarget(render, Tex);
    }
    else
    {
        pscreen = CurTargetSurface;
        if (Sur == nullptr)
        {
            if (TEXT_LAYER != 0)
                CurTargetSurface = TextScreen;
        }
        else
            CurTargetSurface = Sur;
    }

    int w, h;
    if (realPosition == 0)
        GetRealRect(x_pos, y_pos, w, h);

    if (eng == 0)
    {
        DrawText(word, x_pos + 1, y_pos, color2);
        DrawText(word, x_pos, y_pos, color1);
    }
    else
    {
        DrawEngText(word, x_pos + 1, y_pos, color2);
        DrawEngText(word, x_pos, y_pos, color1);
    }

    if (SW_SURFACE == 0)
        SDL_SetRenderTarget(render, ptex);
    else
        CurTargetSurface = pscreen;
}

void DrawEngShadowText(const std::string& word, int x_pos, int y_pos, uint32 color1, uint32 color2,
    SDL_Texture* Tex, SDL_Surface* Sur)
{
    DrawShadowText(word, x_pos, y_pos + 4, color1, color2, Tex, Sur, 0, 1);
}

//----------------------------------------------------------------------
// 矩形绘制
//----------------------------------------------------------------------
void DrawRectangle(int x, int y, int w, int h, uint32 colorin, uint32 colorframe, int alpha, int trans)
{
    if (h <= 35 && trans != 0)
    {
        DrawTextFrame(x - 12, y + 1, w / 10);
        return;
    }

    if (SW_SURFACE == 0)
    {
        uint8_t r, g, b, r1, g1, b1;
        GetRGBA(colorin, &r, &g, &b);
        GetRGBA(colorframe, &r1, &g1, &b1);

        SDL_Texture* ptex = SDL_GetRenderTarget(render);
        SDL_Texture* tex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w + 1, h + 1);
        SDL_SetRenderTarget(render, tex);
        SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
        SDL_SetRenderDrawColor(render, r, g, b, (uint8_t)(alpha * 255 / 100));
        SDL_RenderFillRect(render, nullptr);

        // 圆角处理
        for (int i1 = 0; i1 <= w; i1++)
            for (int i2 = 0; i2 <= h; i2++)
            {
                int l1 = i1 + i2;
                int l2 = -(i1 - w) + i2;
                int l3 = i1 - (i2 - h);
                int l4 = -(i1 - w) - (i2 - h);
                if (!((l1 >= 4) && (l2 >= 4) && (l3 >= 4) && (l4 >= 4)))
                {
                    SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
                    SDL_RenderPoint(render, (float)i1, (float)i2);
                }
            }

        SDL_SetRenderTarget(render, ptex);
        SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
        SDL_FRect destf = { (float)x, (float)y, (float)(w + 1), (float)(h + 1) };
        SDL_RenderTexture(render, tex, nullptr, &destf);
        SDL_DestroyTexture(tex);
    }
    else
    {
        w = abs(w);
        h = abs(h);
        uint8_t r, g, b;
        GetRGBA(colorin, &r, &g, &b);

        SDL_Surface* tempscr = SDL_CreateSurface(w + 1, h + 1,
            SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
        SDL_FillSurfaceRect(tempscr, nullptr, MapRGBA(r, g, b, (uint8_t)(alpha * 255 / 100)));

        for (int i1 = 0; i1 <= w; i1++)
            for (int i2 = 0; i2 <= h; i2++)
            {
                int l1 = i1 + i2;
                int l2 = -(i1 - w) + i2;
                int l3 = i1 - (i2 - h);
                int l4 = -(i1 - w) - (i2 - h);
                if (!((l1 >= 4) && (l2 >= 4) && (l3 >= 4) && (l4 >= 4)))
                    PutPixel(tempscr, i1, i2, 0);
            }

        SDL_Rect dest = { x, y, 0, 0 };
        SDL_BlitSurface(tempscr, nullptr, CurTargetSurface, &dest);
        SDL_DestroySurface(tempscr);
    }
}

void DrawRectangleWithoutFrame(int x, int y, int w, int h, uint32 colorin, int alpha)
{
    uint8_t r, g, b;
    GetRGBA(colorin, &r, &g, &b);
    if (SW_SURFACE == 0 && alpha >= 0)
    {
        SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_BLEND);
        SDL_SetRenderDrawColor(render, r, g, b, (uint8_t)(255 - 255 * alpha / 100));
        SDL_FRect destf = { (float)x, (float)y, (float)w, (float)h };
        SDL_RenderFillRect(render, &destf);
    }
    else
    {
        if (w > 0 && h > 0)
        {
            SDL_Surface* tempsur = SDL_CreateSurface(w, h,
                SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
            SDL_FillSurfaceRect(tempsur, nullptr, MapRGBA(r, g, b, (uint8_t)(255 - alpha * 255 / 100)));
            SDL_SetSurfaceBlendMode(tempsur, SDL_BLENDMODE_BLEND);
            SDL_Rect dest = { x, y, w, h };
            if (SW_SURFACE == 0)
            {
                SDL_Texture* temptex = SDL_CreateTextureFromSurface(render, tempsur);
                SDL_SetTextureBlendMode(temptex, SDL_BLENDMODE_BLEND);
                SDL_FRect destf = { (float)x, (float)y, (float)w, (float)h };
                SDL_RenderTexture(render, temptex, nullptr, &destf);
                SDL_DestroyTexture(temptex);
            }
            else
                SDL_BlitSurface(tempsur, nullptr, CurTargetSurface, &dest);
            SDL_DestroySurface(tempsur);
        }
    }
}

void DrawItemFrame(int x, int y, int realcoord)
{
    int d = 83, d2 = 80;
    if (realcoord == 0)
    {
        int xp = CENTER_X - 200;
        int yp = 75;
        x = x * d + 5 + xp;
        y = y * d + 35 + yp;
    }
    else
    {
        x -= 1;
        y -= 1;
    }

    if (SW_SURFACE == 0)
    {
        for (int i = 0; i <= d2; i++)
        {
            uint8_t t = (uint8_t)(250 - i * 2);
            SDL_SetRenderDrawColor(render, t, t, t, 255);
            SDL_RenderPoint(render, (float)(x + i), (float)y);
            SDL_RenderPoint(render, (float)(x + d2 - i), (float)(y + d2));
            SDL_RenderPoint(render, (float)x, (float)(y + i));
            SDL_RenderPoint(render, (float)(x + d2), (float)(y + d2 - i));
        }
    }
}

void DrawPartPic(void* pic, int x, int y, int w, int h, int x1, int y1)
{
    if (pic == nullptr) return;
    SDL_FRect src = { (float)x, (float)y, (float)w, (float)h };
    SDL_FRect dst = { (float)x1, (float)y1, (float)w, (float)h };
    if (SW_SURFACE == 0)
        SDL_RenderTexture(render, (SDL_Texture*)pic, &src, &dst);
    else
    {
        SDL_Rect srci = { x, y, w, h };
        SDL_Rect dsti = { x1, y1, w, h };
        SDL_BlitSurface((SDL_Surface*)pic, &srci, screen, &dsti);
    }
}

//----------------------------------------------------------------------
// 鼠标位置
//----------------------------------------------------------------------
void SDL_GetMouseState2(int& x, int& y)
{
    float xf, yf;
    SDL_GetMouseState(&xf, &yf);
    int tempx = (int)xf, tempy = (int)yf;
    if (ScreenRotate == 1)
    {
        x = (int)(tempy * 1.0 / RESOLUTIONY * CENTER_X * 2);
        y = CENTER_Y * 2 - (int)(tempx * 1.0 / RESOLUTIONX * CENTER_Y * 2);
        return;
    }
    if (KEEP_SCREEN_RATIO == 1)
    {
        TStretchInfo s = KeepRatioScale(CENTER_X * 2, CENTER_Y * 2, RESOLUTIONX, RESOLUTIONY);
        x = (tempx - s.px) * s.den / s.num;
        y = (tempy - s.py) * s.den / s.num;
    }
    else
    {
        x = (int)(tempx * 1.0 / RESOLUTIONX * CENTER_X * 2);
        y = (int)(tempy * 1.0 / RESOLUTIONY * CENTER_Y * 2);
    }
}

//----------------------------------------------------------------------
// 纹理管理
//----------------------------------------------------------------------
void DestroyRenderTextures()
{
    if (TEXT_LAYER == 1)
    {
        SDL_DestroyTexture(TextScreenTex);
        if (SW_SURFACE != 0)
            SDL_DestroySurface(TextScreen);
    }
}

void CreateAssistantRenderTextures()
{
    if (TEXT_LAYER == 1)
    {
        if (SW_SURFACE == 0)
        {
            TextScreenTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, RESOLUTIONX, RESOLUTIONY);
            SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
            CleanTextScreen();
        }
        else
        {
            TextScreen = SDL_CreateSurface(RESOLUTIONX, RESOLUTIONY,
                SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
            TextScreenTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, RESOLUTIONX, RESOLUTIONY);
            SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
        }
        ResizeSimpleText(1);
        TTF_CloseFont(Font);
        TTF_CloseFont(EngFont);
        SetFontSize(20, 18, -1);
    }
}

void CreateMainRenderTextures()
{
    if (SW_SURFACE == 0)
    {
        screenTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_UNKNOWN, SDL_TEXTUREACCESS_TARGET, CENTER_X * 2, CENTER_Y * 2);
        ImgSGroundTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, ImageWidth, ImageHeight);
        ImgBGroundTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, ImageWidth, ImageHeight);
        SimpleStateTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, 960, 90);
        for (int i = 0; i < 6; i++)
            SimpleStatusTex[i] = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, 270, 90);

        SDL_SetTextureBlendMode(screenTex, SDL_BLENDMODE_NONE);
        SDL_SetTextureBlendMode(ImgSGroundTex, SDL_BLENDMODE_NONE);
        SDL_SetTextureBlendMode(ImgBGroundTex, SDL_BLENDMODE_NONE);
        SDL_SetTextureBlendMode(SimpleStateTex, SDL_BLENDMODE_BLEND);
        SDL_SetRenderTarget(render, screenTex);
    }
    else
    {
        screen = SDL_CreateSurface(CENTER_X * 2, CENTER_Y * 2,
            SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
        ImgSGround = SDL_CreateSurface(ImageWidth, ImageHeight,
            SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
        ImgBGround = SDL_CreateSurface(ImageWidth, ImageHeight,
            SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
        SimpleState = SDL_CreateSurface(270, 90,
            SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
        for (int i = 0; i < 6; i++)
            SimpleStatus[i] = SDL_CreateSurface(270, 90,
                SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
        CurTargetSurface = screen;
        screenTex = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, CENTER_X * 2, CENTER_Y * 2);
        SDL_SetTextureBlendMode(screenTex, SDL_BLENDMODE_NONE);
    }
}

void ResizeWindow(int w, int h)
{
    RESOLUTIONX = w;
    RESOLUTIONY = h;
    SDL_SetRenderTarget(render, nullptr);
    DestroyRenderTextures();
    SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
    SDL_SetWindowSize(window, w, h);
    SDL_RenderClear(render);
    CreateAssistantRenderTextures();
    SDL_SetRenderTarget(render, screenTex);
    int temp;
    if (MenuEscType >= 0) LoadTeamSimpleStatus(temp);
    UpdateAllScreen();
}

void ResizeSimpleText(int initial)
{
    if (TEXT_LAYER == 1)
    {
        int x = 0, y = 0, w1 = 270, h1 = 90;
        GetRealRect(x, y, w1, h1);
        for (int i = 0; i < 6; i++)
        {
            if (SW_SURFACE == 0)
            {
                if (SimpleTextTex[i] != nullptr) SDL_DestroyTexture(SimpleTextTex[i]);
                SimpleTextTex[i] = SDL_CreateTexture(render, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, w1 + x, y + h1);
                SDL_SetTextureBlendMode(SimpleTextTex[i], SDL_BLENDMODE_NONE);
            }
            else
            {
                if (SimpleText[i] != nullptr) SDL_DestroySurface(SimpleText[i]);
                SimpleText[i] = SDL_CreateSurface(w1 + x, y + h1,
                    SDL_GetPixelFormatForMasks(32, RMask, GMask, BMask, AMask));
            }
        }
    }
}

void SwitchFullscreen()
{
    FULLSCREEN = 1 - FULLSCREEN;
}

void QuitConfirm()
{
    if (EXIT_GAME == 0 || AskingQuit)
        return;

    AskingQuit = true;
    RecordFreshScreen();
    TransBlackScreen();
    UpdateAllScreen();
    std::string menuStr[] = { "取消", "確認" };
    if (CommonMenu(CENTER_X * 2 - 100, 10, 47, 1, 0, menuStr, 2) == 1)
        Quit();
    LoadFreshScreen();
    FreeFreshScreen();
    UpdateAllScreen();
    AskingQuit = false;
}

uint32 JoyAxisMouse(uint32 interval, void* param)
{
    float xf, yf;
    SDL_GetMouseState(&xf, &yf);
    int x = (int)xf, y = (int)yf;
    int x1 = SDL_GetJoystickAxis(joy, 0);
    int y1 = SDL_GetJoystickAxis(joy, 1);
    if (abs(x1) + abs(y1) > 10000)
    {
        x += x1 / 1000;
        y += y1 / 1000;
        SDL_WarpMouseInWindow(window, (float)x, (float)y);
    }
    return JOY_AXIS_DELAY;
}

//----------------------------------------------------------------------
// CheckBasicEvent
//----------------------------------------------------------------------
uint32 CheckBasicEvent()
{
    SDL_FlushEvent(SDL_EVENT_MOUSE_WHEEL);
    SDL_FlushEvent(SDL_EVENT_JOYSTICK_AXIS_MOTION);
    SDL_FlushEvent(SDL_EVENT_FINGER_MOTION);
    if (CellPhone == 1) SDL_FlushEvent(SDL_EVENT_MOUSE_MOTION);

    uint32 result = event.type;
    switch (event.type)
    {
    case SDL_EVENT_JOYSTICK_BUTTON_UP:
        event.type = SDL_EVENT_KEY_UP;
        if (event.jbutton.button == JOY_ESCAPE) event.key.key = SDLK_ESCAPE;
        else if (event.jbutton.button == JOY_RETURN) event.key.key = SDLK_RETURN;
        else if (event.jbutton.button == JOY_MOUSE_LEFT)
        {
            event.button.button = SDL_BUTTON_LEFT;
            event.type = SDL_EVENT_MOUSE_BUTTON_UP;
        }
        else if (event.jbutton.button == JOY_UP) event.key.key = SDLK_UP;
        else if (event.jbutton.button == JOY_DOWN) event.key.key = SDLK_DOWN;
        else if (event.jbutton.button == JOY_LEFT) event.key.key = SDLK_LEFT;
        else if (event.jbutton.button == JOY_RIGHT) event.key.key = SDLK_RIGHT;
        break;
    case SDL_EVENT_JOYSTICK_BUTTON_DOWN:
        event.type = SDL_EVENT_KEY_DOWN;
        if (event.jbutton.button == JOY_UP) event.key.key = SDLK_UP;
        else if (event.jbutton.button == JOY_DOWN) event.key.key = SDLK_DOWN;
        else if (event.jbutton.button == JOY_LEFT) event.key.key = SDLK_LEFT;
        else if (event.jbutton.button == JOY_RIGHT) event.key.key = SDLK_RIGHT;
        break;
    case SDL_EVENT_JOYSTICK_HAT_MOTION:
        event.type = SDL_EVENT_KEY_DOWN;
        switch (event.jhat.value)
        {
        case SDL_HAT_UP: event.key.key = SDLK_UP; break;
        case SDL_HAT_DOWN: event.key.key = SDLK_DOWN; break;
        case SDL_HAT_LEFT: event.key.key = SDLK_LEFT; break;
        case SDL_HAT_RIGHT: event.key.key = SDLK_RIGHT; break;
        }
        break;
    case SDL_EVENT_FINGER_MOTION:
        if (CellPhone == 1)
        {
            if (event.tfinger.fingerID == 1)
            {
                uint32 msCount = SDL_GetTicks() - FingerTick;
                uint32 msWait = BattleSelecting ? 100 : 50;
                if (msCount > 500) FingerCount = 1;
                if ((FingerCount <= 2 && msCount > 200) || (FingerCount > 2 && msCount > msWait))
                {
                    FingerCount++;
                    FingerTick = SDL_GetTicks();
                    event.type = SDL_EVENT_KEY_DOWN;
                    event.key.key = AngleToDirection(event.tfinger.dy, event.tfinger.dx);
                }
            }
        }
        break;
    case SDL_EVENT_QUIT:
        QuitConfirm();
        break;
    case SDL_EVENT_WINDOW_RESIZED:
        ResizeWindow(event.window.data1, event.window.data2);
        break;
    case SDL_EVENT_DID_ENTER_FOREGROUND:
        PlayMP3(NowMusic, -1, 0);
        break;
    case SDL_EVENT_DID_ENTER_BACKGROUND:
        StopMP3(0);
        break;
    case SDL_EVENT_MOUSE_BUTTON_DOWN:
        if (CellPhone == 1 && ShowVirtualKey != 0)
        {
            int x, y;
            SDL_GetMouseState2(x, y);
            // TODO: 虚拟按键检�?
        }
        break;
    case SDL_EVENT_KEY_UP:
    case SDL_EVENT_MOUSE_BUTTON_UP:
        if (CellPhone == 1 && event.type == SDL_EVENT_MOUSE_BUTTON_UP && event.button.button == SDL_BUTTON_LEFT)
        {
            int x, y;
            SDL_GetMouseState2(x, y);
            // TODO: 触屏按钮转换
        }
        if (Where == 2 && (event.key.key == SDLK_ESCAPE || event.button.button == SDL_BUTTON_RIGHT))
        {
            for (int i = 0; i < BRoleAmount; i++)
                if (Brole[i].Team == 0) Brole[i].Auto = 0;
        }
        if (event.key.key == SDLK_KP_ENTER) event.key.key = SDLK_RETURN;
        break;
    }
    return result;
}

int AngleToDirection(double y, double x)
{
    int result = 0;
    double angle = atan2(-y, x);
    double ar = M_PI / 4;
    if (fabs(angle + M_PI / 8) < ar) result = SDLK_RIGHT;
    if (fabs(angle - M_PI * 3 / 8) < ar) result = SDLK_UP;
    if (fabs(angle - M_PI * 7 / 8) < ar || angle < -M_PI * 7 / 8) result = SDLK_LEFT;
    if (fabs(angle + M_PI * 5 / 8) < ar) result = SDLK_DOWN;
    if (ScreenRotate == 1)
    {
        switch (result)
        {
        case SDLK_UP: result = SDLK_LEFT; break;
        case SDLK_DOWN: result = SDLK_RIGHT; break;
        case SDLK_LEFT: result = SDLK_DOWN; break;
        case SDLK_RIGHT: result = SDLK_UP; break;
        }
    }
    return result;
}

void ChangeCol()
{
    if (PNG_TILE == 0)
    {
        uint32 now = SDL_GetTicks();
        if (NIGHT_EFFECT == 1 && Where == 0)
        {
            now_time += 0.3f;
            if (now_time > 1440) now_time = 0;
            float p = now_time / 1440.0f;
            if (p > 0.5f) p = 1 - p;
            float p0 = 0.6f + p, p1 = 0.6f + p, p2 = 1 - 0.4f / 1.3f + p / 1.3f;
            for (int i = 0; i < 256; i++)
            {
                int b = i * 3;
                ACol1[b] = (uint8_t)std::min((int)(ACol2[b] * p0), 63);
                ACol1[b + 1] = (uint8_t)std::min((int)(ACol2[b + 1] * p1), 63);
                ACol1[b + 2] = (uint8_t)std::min((int)(ACol2[b + 2] * p2), 63);
            }
            memcpy(ACol, ACol1, 768);
        }

        int add0 = 0xE0, len = 8;
        int a = now / 200 % len;
        memcpy(&ACol[add0 * 3 + a * 3], &ACol1[add0 * 3], (len - a) * 3);
        memcpy(&ACol[add0 * 3], &ACol1[add0 * 3 + (len - a) * 3], a * 3);

        add0 = 0xF4; len = 9;
        a = now / 200 % len;
        memcpy(&ACol[add0 * 3 + a * 3], &ACol1[add0 * 3], (len - a) * 3);
        memcpy(&ACol[add0 * 3], &ACol1[add0 * 3 + (len - a) * 3], a * 3);
    }
}

//----------------------------------------------------------------------
// IO / 贴图
//----------------------------------------------------------------------
void InitialPicArrays()
{
    if (PNG_TILE > 0)
    {
        MPicAmount = LoadPNGTiles("resource/mmap", MPNGIndex, PNG_LOAD_ALL);
        SPicAmount = LoadPNGTiles("resource/smap", SPNGIndex, PNG_LOAD_ALL);
        HPicAmount = LoadPNGTiles("resource/head", HPNGIndex, PNG_LOAD_ALL);
        IPicAmount = LoadPNGTiles("resource/item", IPNGIndex, PNG_LOAD_ALL);
        CPicAmount = LoadPNGTiles("resource/cloud", CPNGIndex, 1);
        pMPic = nullptr; pSPic = nullptr; pHPic = nullptr; pIPic = nullptr;

        if (PNG_TILE == 2 && PNG_LOAD_ALL == 0)
        {
            // TODO: zip_open for tiles
        }
        ReadTiles();
    }
}

void ReadTiles()
{
    if (PNG_TILE > 0 && PNG_LOAD_ALL == 0)
    {
        for (int i = 2001; i < MPicAmount; i++)
            LoadOnePNGTexture("resource/mmap", pMPic, MPNGIndex[i]);
        for (int i = 2501; i <= 2528; i++)
            LoadOnePNGTexture("resource/smap", pSPic, SPNGIndex[i]);
    }
    ReadingTiles = false;
}

int LoadPNGTilesThread(void* Data)
{
    // TODO: 多线程加载贴�?
    return 0;
}

char* ReadFileToBuffer(char* p, const std::string& filename, int size, int malloc_flag)
{
    FILE* f = fopen(filename.c_str(), "rb");
    if (f)
    {
        if (size < 0)
        {
            fseek(f, 0, SEEK_END);
            size = (int)ftell(f);
        }
        if (malloc_flag == 1)
        {
            p = new char[size + 4];
        }
        fseek(f, 0, SEEK_SET);
        fread(p, 1, size, f);
        fclose(f);
        return p;
    }
    return (malloc_flag == 1) ? nullptr : p;
}

void ReadTxtFileToBuffer(char* p, const std::string& filename)
{
    std::string content = filefunc::readFileToString(filename);
    auto nums = strfunc::findNumbers<int>(content);
    if (!nums.empty())
        memcpy(p, nums.data(), nums.size() * 4);
}

int FileGetlength(const std::string& filename) { return 0; }
void FreeFileBuffer(char*& p) { delete[] p; p = nullptr; }

TIDXGRP LoadIdxGrp(const std::string& stridx, const std::string& strgrp)
{
    TIDXGRP result;
    result.Amount = 0;
    std::string idxfile = AppPath + stridx;
    std::string grpfile = AppPath + strgrp;
    if (filefunc::fileExist(grpfile) && filefunc::fileExist(idxfile))
    {
        std::string idxdata = filefunc::readFileToString(idxfile);
        std::string grpdata = filefunc::readFileToString(grpfile);
        int tnum = (int)(idxdata.size() / 4);
        result.IDX.resize(tnum + 1);
        result.IDX[0] = 0;
        memcpy(&result.IDX[1], idxdata.data(), tnum * 4);
        result.GRP.resize(grpdata.size() + 4);
        memcpy(result.GRP.data(), grpdata.data(), grpdata.size());
        result.Amount = tnum;
    }
    return result;
}

int LoadPNGTiles(const std::string& path, TPNGIndexArray& PNGIndexArray, int LoadPic, int16_t* frame)
{
    // TODO: 完整的PNG贴图索引加载
    int result = 0;

    // 尝试从zip加载
    if (PNG_TILE == 2)
    {
        // TODO: zip加载
    }

    // 从文件夹加载
    if (PNG_TILE == 1 || result == 0)
    {
        std::string fullpath = AppPath + path + "/";
        std::string indexFile = fullpath + "index.ka";
        if (filefunc::fileExist(indexFile))
        {
            std::string data = filefunc::readFileToString(indexFile);
            result = (int)(data.size() / 4);
            std::vector<int16_t> offset(result * 2 + 2, 0);
            if (!data.empty())
                memcpy(offset.data(), data.data(), std::min(data.size(), offset.size() * 2));

            PNGIndexArray.resize(result);
            int count = 0;
            for (int i = 0; i < result; i++)
            {
                PNGIndexArray[i].FileNum = i;
                PNGIndexArray[i].PointerNum = count;
                PNGIndexArray[i].Frame = 1;
                PNGIndexArray[i].x = offset[i * 2];
                PNGIndexArray[i].y = offset[i * 2 + 1];
                PNGIndexArray[i].Loaded = 0;
                PNGIndexArray[i].UseGRP = 0;
                PNGIndexArray[i].Pointers.resize(1, nullptr);
                count++;
            }
        }
    }
    return result;
}

void LoadOnePNGTexture(const std::string& path, void* z, TPNGIndex& PNGIndex, int forceLoad)
{
    // TODO: 从文�?zip载入一张PNG贴图
    if (PNGIndex.Loaded != 0 && forceLoad == 0) return;
    // 加载逻辑
    PNGIndex.Loaded = 1;
}

bool LoadTileFromFile(const std::string& filename, void*& pt, int usesur, int& w, int& h)
{
    // TODO: 从文件加载贴�?
    return false;
}

bool LoadTileFromMem(const char* p, int len, void*& pt, int usesur, int& w, int& h)
{
    // TODO: 从内存加载贴�?
    return false;
}

std::string LoadStringFromIMZMEM(const std::string& path, const char* p, int num)
{
    // TODO
    return "";
}

void DestroyAllTextures(int all)
{
    for (auto& pair : CharTex)
    {
        if (SW_SURFACE == 0)
            SDL_DestroyTexture((SDL_Texture*)pair.second);
        else
            SDL_DestroySurface((SDL_Surface*)pair.second);
    }
    CharTex.clear();
}

void DestroyFontTextures()
{
    DestroyAllTextures(0);
}

void DrawPNGTile(SDL_Renderer* r, TPNGIndex& PNGIndex, int FrameNum, int px, int py)
{
    DrawPNGTile(r, PNGIndex, FrameNum, px, py, nullptr, 0, 255, 0, 0, 1.0, 1.0, 0, nullptr);
}

void DrawPNGTile(SDL_Renderer* r, TPNGIndex& PNGIndex, int FrameNum, int px, int py,
    SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha,
    double scalex, double scaley, double angle, SDL_Point* center)
{
    if (FrameNum < 0 || FrameNum >= PNGIndex.Frame) return;
    if (PNGIndex.Pointers.empty()) return;

    SDL_Texture* tex = (SDL_Texture*)PNGIndex.Pointers[FrameNum];
    if (tex == nullptr) return;

    float wf, hf;
    SDL_GetTextureSize(tex, &wf, &hf);
    int w = (int)wf, h = (int)hf;

    SDL_FRect dest;
    dest.x = (float)(px + PNGIndex.x);
    dest.y = (float)(py + PNGIndex.y);
    dest.w = (float)(w * scalex);
    dest.h = (float)(h * scaley);

    SDL_SetTextureAlphaMod(tex, (uint8_t)alpha);
    if (shadow != 0) SDL_SetTextureColorMod(tex, 0, 0, 0);
    else SDL_SetTextureColorMod(tex, 255, 255, 255);

    if (angle != 0 || (center != nullptr))
    {
        SDL_FPoint fcenter = { 0, 0 };
        if (center) { fcenter.x = (float)center->x; fcenter.y = (float)center->y; }
        SDL_RenderTextureRotated(r, tex, nullptr, &dest, angle, &fcenter, SDL_FLIP_NONE);
    }
    else
        SDL_RenderTexture(r, tex, nullptr, &dest);
}

void DrawPNGTileS(SDL_Surface* scr, TPNGIndex& PNGIndex, int FrameNum, int px, int py,
    SDL_Rect* region, int shadow, int alpha, uint32 mixColor, int mixAlpha,
    double scalex, double scaley, double angle)
{
    // TODO: Surface模式的贴图绘�?
}

bool PlayMovie(const std::string& filename)
{
    // TODO: 使用potdll播放视频
    return false;
}

int DrawLength(const std::string& str)
{
    int len = 0;
    for (size_t i = 0; i < str.size();)
    {
        unsigned char c = (unsigned char)str[i];
        if (c < 128)
        {
            len += ENGLISH_FONT_REALSIZE / 2;
            i++;
        }
        else
        {
            len += CHINESE_FONT_REALSIZE;
            i += utf8follow(str[i]);
        }
    }
    return len;
}

int DrawLength(const char* p)
{
    if (p == nullptr) return 0;
    return DrawLength(std::string(p));
}

//----------------------------------------------------------------------
// 屏幕控制
//----------------------------------------------------------------------
void SetFontSize(int Chnsize, int engsize, int force)
{
    CHINESE_FONT_SIZE = Chnsize;
    ENGLISH_FONT_SIZE = engsize;
    CHINESE_FONT_REALSIZE = Chnsize;
    ENGLISH_FONT_REALSIZE = engsize;

    std::string fontfile = AppPath + "font/chinese.ttf";
    std::string engfontfile = AppPath + "font/english.ttf";

    if (filefunc::fileExist(fontfile))
        Font = TTF_OpenFont(fontfile.c_str(), (float)Chnsize);
    if (filefunc::fileExist(engfontfile))
        EngFont = TTF_OpenFont(engfontfile.c_str(), (float)engsize);
}

void ResetFontSize()
{
    SetFontSize(20, 18, -1);
}

void LoadTeamSimpleStatus(int& max)
{
    // TODO: 加载队伍简略状�?
    max = 0;
}

void DrawSimpleStatusByTeam(int i, int px, int py, uint32 mixColor, int mixAlpha)
{
    // TODO
}

void FreeTeamSimpleStatus(SDL_Surface** SimpleStatusArr, int count)
{
    for (int i = 0; i < count; i++)
        if (SimpleStatusArr[i]) { SDL_DestroySurface(SimpleStatusArr[i]); SimpleStatusArr[i] = nullptr; }
}

void TransBlackScreen()
{
    DrawRectangleWithoutFrame(0, 0, CENTER_X * 2, CENTER_Y * 2, MapRGBA(0, 0, 0), 30);
}

void RecordFreshScreen()
{
    // TODO: 记录当前画面
}

void LoadFreshScreen()
{
    // TODO: 恢复画面
}

void RecordFreshScreen(int x, int y, int w, int h) { /* TODO */ }
void LoadFreshScreen(int x, int y) { /* TODO */ }
void FreeFreshScreen() { /* TODO */ }

void UpdateAllScreen()
{
    if (SW_SURFACE == 0)
    {
        SDL_SetRenderTarget(render, nullptr);
        SDL_FRect src = { 0, 0, (float)(CENTER_X * 2), (float)(CENTER_Y * 2) };
        SDL_FRect dst;
        if (KEEP_SCREEN_RATIO == 1)
        {
            TStretchInfo s = KeepRatioScale(CENTER_X * 2, CENTER_Y * 2, RESOLUTIONX, RESOLUTIONY);
            dst = { (float)s.px, (float)s.py, (float)(CENTER_X * 2 * s.num / s.den), (float)(CENTER_Y * 2 * s.num / s.den) };
        }
        else
        {
            dst = { 0, 0, (float)RESOLUTIONX, (float)RESOLUTIONY };
        }
        SDL_RenderTexture(render, screenTex, &src, &dst);
        if (TEXT_LAYER == 1)
        {
            SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
            SDL_FRect fulldst = { 0, 0, (float)RESOLUTIONX, (float)RESOLUTIONY };
            SDL_RenderTexture(render, TextScreenTex, nullptr, &fulldst);
        }
        SDL_RenderPresent(render);
        SDL_SetRenderTarget(render, screenTex);
    }
    else
    {
        // SW模式: surface -> texture -> present
        if (screen)
        {
            void* pixels;
            int pitch;
            SDL_LockTexture(screenTex, nullptr, &pixels, &pitch);
            for (int y = 0; y < CENTER_Y * 2; y++)
                memcpy((uint8_t*)pixels + y * pitch, (uint8_t*)screen->pixels + y * screen->pitch, CENTER_X * 2 * 4);
            SDL_UnlockTexture(screenTex);
        }
        SDL_SetRenderTarget(render, nullptr);
        SDL_FRect fulldst = { 0, 0, (float)RESOLUTIONX, (float)RESOLUTIONY };
        SDL_RenderTexture(render, screenTex, nullptr, &fulldst);
        if (TEXT_LAYER == 1 && TextScreenTex)
        {
            SDL_SetTextureBlendMode(TextScreenTex, SDL_BLENDMODE_BLEND);
            SDL_RenderTexture(render, TextScreenTex, nullptr, &fulldst);
        }
        SDL_RenderPresent(render);
    }
}

void CleanTextScreen()
{
    if (TEXT_LAYER == 1)
    {
        if (SW_SURFACE == 0)
        {
            SDL_Texture* ptex = SDL_GetRenderTarget(render);
            SDL_SetRenderTarget(render, TextScreenTex);
            SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
            SDL_RenderClear(render);
            SDL_SetRenderTarget(render, ptex);
        }
        else if (TextScreen)
        {
            SDL_FillSurfaceRect(TextScreen, nullptr, 0);
        }
    }
}

void CleanTextScreenRect(int x, int y, int w, int h)
{
    if (TEXT_LAYER == 1)
    {
        if (SW_SURFACE == 0)
        {
            SDL_Texture* ptex = SDL_GetRenderTarget(render);
            SDL_SetRenderTarget(render, TextScreenTex);
            SDL_SetRenderDrawBlendMode(render, SDL_BLENDMODE_NONE);
            SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
            SDL_FRect rect = { (float)x, (float)y, (float)w, (float)h };
            SDL_RenderFillRect(render, &rect);
            SDL_SetRenderTarget(render, ptex);
        }
    }
}

void CleanKeyValue()
{
    event.type = 0;
    event.key.key = 0;
    event.button.button = 0;
}

//----------------------------------------------------------------------
// 位置/区域判断
//----------------------------------------------------------------------
void GetMousePosition(int& x, int& y, int x0, int y0, int yp)
{
    SDL_GetMouseState2(x, y);
    x -= x0;
    y -= y0 + yp;
}

bool InRegion(int x1, int y1, int x, int y, int w, int h)
{
    return x1 >= x && x1 < x + w && y1 >= y && y1 < y + h;
}

bool InRegion(int x, int x1, int x2)
{
    return x >= x1 && x <= x2;
}

bool MouseInRegion(int x, int y, int w, int h)
{
    int mx, my;
    SDL_GetMouseState2(mx, my);
    return InRegion(mx, my, x, y, w, h);
}

bool MouseInRegion(int x, int y, int w, int h, int& x1, int& y1)
{
    SDL_GetMouseState2(x1, y1);
    return InRegion(x1, y1, x, y, w, h);
}

void GetRealRect(int& x, int& y, int& w, int& h, int force)
{
    if (KEEP_SCREEN_RATIO == 1 || force)
    {
        TStretchInfo s = KeepRatioScale(CENTER_X * 2, CENTER_Y * 2, RESOLUTIONX, RESOLUTIONY);
        x = x * s.num / s.den + s.px;
        y = y * s.num / s.den + s.py;
        w = w * s.num / s.den;
        h = h * s.num / s.den;
    }
    else
    {
        x = x * RESOLUTIONX / (CENTER_X * 2);
        y = y * RESOLUTIONY / (CENTER_Y * 2);
        w = w * RESOLUTIONX / (CENTER_X * 2);
        h = h * RESOLUTIONY / (CENTER_Y * 2);
    }
}

SDL_Rect GetRealRect(SDL_Rect rect, int force)
{
    GetRealRect(rect.x, rect.y, rect.w, rect.h, force);
    return rect;
}

TStretchInfo KeepRatioScale(int w1, int h1, int w2, int h2)
{
    TStretchInfo s;
    if (w2 * h1 > w1 * h2)
    {
        s.num = h2;
        s.den = h1;
        s.px = (w2 - w1 * h2 / h1) / 2;
        s.py = 0;
    }
    else
    {
        s.num = w2;
        s.den = w1;
        s.px = 0;
        s.py = (h2 - h1 * w2 / w1) / 2;
    }
    return s;
}

void swap(uint8_t& x, uint8_t& y) { uint8_t t = x; x = y; y = t; }
void swap(uint32& x, uint32& y) { uint32 t = x; x = y; y = t; }

int RegionParameter(int x, int x1, int x2)
{
    if (x < x1) return x1;
    if (x > x2) return x2;
    return x;
}

int LinearInsert(double x, double x1, double x2, int y1, int y2)
{
    if (x2 == x1) return y1;
    return (int)(y1 + (x - x1) / (x2 - x1) * (y2 - y1));
}

void QuickSort(int* a, int l, int r)
{
    if (l >= r) return;
    int i = l, j = r, x = a[(l + r) / 2];
    while (i <= j)
    {
        while (a[i] < x) i++;
        while (a[j] > x) j--;
        if (i <= j) { int t = a[i]; a[i] = a[j]; a[j] = t; i++; j--; }
    }
    if (l < j) QuickSort(a, l, j);
    if (i < r) QuickSort(a, i, r);
}

void QuickSortB(TBuildInfo* a, int l, int r)
{
    if (l >= r) return;
    int i = l, j = r;
    int x = a[(l + r) / 2].c;
    while (i <= j)
    {
        while (a[i].c < x) i++;
        while (a[j].c > x) j--;
        if (i <= j) { TBuildInfo t = a[i]; a[i] = a[j]; a[j] = t; i++; j--; }
    }
    if (l < j) QuickSortB(a, l, j);
    if (i < r) QuickSortB(a, i, r);
}

static uint32 tic_time = 0;
void tic() { tic_time = SDL_GetTicks(); }
void toc() { kyslog("Time elapsed: %d ms", SDL_GetTicks() - tic_time); }

std::string readFiletostring(const std::string& filename)
{
    return filefunc::readFileToString(filename);
}

std::vector<int> readnumbersformstring(const std::string& str)
{
    return strfunc::findNumbers<int>(str);
}

SDL_FRect Rect2f(SDL_Rect r) { return { (float)r.x, (float)r.y, (float)r.w, (float)r.h }; }
SDL_Rect Rectf2(SDL_FRect r) { return { (int)r.x, (int)r.y, (int)r.w, (int)r.h }; }
