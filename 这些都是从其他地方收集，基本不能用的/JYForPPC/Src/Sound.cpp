
#include "sound.h"
#include "util.h"
#include "oggplay.h"

static BOOL gSndOpened = FALSE;

BOOL       g_fNoSound = FALSE;
BOOL       g_fNoMusic = FALSE;

typedef struct tagSNDPLAYER
{
   FILE                     *snd;
   SDL_AudioSpec             spec;
   LPBYTE                    buf[2], pos[2];
   INT                       audio_len[2];
} SNDPLAYER;

static SNDPLAYER gSndPlayer;

struct RIFF_HEADER
{
	char szRiffID[4];  // 'R','I','F','F'
	DWORD dwRiffSize;
	char szRiffFormat[4]; // 'W','A','V','E'
};
//struct WAVE_FORMAT
//{
//	WORD wFormatTag;
//	WORD wChannels;
//	DWORD dwSamplesPerSec;
//	DWORD dwAvgBytesPerSec;
//	WORD wBlockAlign;
//	WORD wBitsPerSample;
//};
//struct DATA_BLOCK
//{
//	char szDataID[4]; // 'd','a','t','a'
//	DWORD dwDataSize;
//};
static SDL_AudioSpec *SOUND_LoadVOCFromBuffer(LPCBYTE lpVOC,SDL_AudioSpec *lpSpec,LPBYTE *lppBuffer)
{
	INT freq, len, x, i, l;

	//
	// Skip header
	//
	lpVOC += 0x1B;

	//
	// Length is 3 bytes long
	//
	len = arByte2Int((void*)lpVOC, 2); // seacat len = SWAP16(*(LPWORD)lpVOC);
	lpVOC += 2;
	x = *(lpVOC++);
	x <<= 16;
	len += x - 2;

	//
	// One byte for frequency
	//
	freq = 1000000 / (256 - *lpVOC);

	#if 1

	lpVOC += 2;

	//
	// Convert the sample to 22050Hz manually, as SDL doesn't like "strange" sample rates.
	//
	x = (INT)(len * (22050.0 / freq));

	*lppBuffer = (LPBYTE)calloc(1, x);
	if (*lppBuffer == NULL)
	{
		return NULL;
	}
	for (i = 0; i < x; i++)
	{
		l = (INT)(i * (freq / 22050.0));
		if (l < 0)
		{
		 l = 0;
		}
		else if (l >= len)
		{
		 l = len - 1;
		}
		(*lppBuffer)[i] = lpVOC[l];
	}

	lpSpec->channels = 1;
	lpSpec->format = AUDIO_U8;
	lpSpec->freq = 22050;
	lpSpec->size = x;

	#else

	*lppBuffer = (unsigned char *)malloc(len);
	if (*lppBuffer == NULL)
	{
	  return NULL;
	}

	lpSpec->channels = 1;
	lpSpec->format = AUDIO_U8;
	lpSpec->freq = freq;
	lpSpec->size = len;

	lpVOC += 2;
	memcpy(*lppBuffer, lpVOC, len);

	#endif

	return lpSpec;
}



static VOID SDLCALL SOUND_FillAudio(LPVOID udata,LPBYTE stream,INT len)
{
	int        i;

	//
	// Play music
	//
	if (!g_fNoMusic)
	{
		OGG_FillBuffer(stream, len);
	}

	//
	// No current playing sound
	//
	if (g_fNoSound)
	{
		return;
	}

	for (i = 0; i < 2; i++)
	{
		//
		// Only play if we have data left
		//
		if (gSndPlayer.buf[i] == NULL)
		{
		 continue;
		}

		if (gSndPlayer.audio_len[i] == 0)
		{
		 //
		 // Delete the audio buffer from memory
		 //
		 free(gSndPlayer.buf[i]);
		 gSndPlayer.buf[i] = NULL;
		 continue;
		}

		//
		// Mix as much data as possible
		//
		len = (len > gSndPlayer.audio_len[i]) ? gSndPlayer.audio_len[i] : len;
		#ifdef __SYMBIAN32__
			SDL_MixAudio(stream, gSndPlayer.pos[i], len, g_iVolume);
		#else
			SDL_MixAudio(stream, gSndPlayer.pos[i], len, SDL_MIX_MAXVOLUME);
		#endif
		gSndPlayer.pos[i] += len;
		gSndPlayer.audio_len[i] -= len;
	}
}


INT SOUND_OpenAudio(VOID)
{
	SDL_AudioSpec spec;

	if (gSndOpened)
	{
	  return -1;
	}

	gSndOpened = FALSE;

	gSndPlayer.spec.freq = 22050;//22050;
	gSndPlayer.spec.format = AUDIO_S16;
	gSndPlayer.spec.channels = 1;
	gSndPlayer.spec.samples = 4096;//4096;//
	gSndPlayer.spec.callback = SOUND_FillAudio;

	if (SDL_OpenAudio(&gSndPlayer.spec, &spec) < 0)
	{
		return -3;
	}

	memcpy(&gSndPlayer.spec, &spec, sizeof(SDL_AudioSpec));

	gSndPlayer.buf[0] = NULL;
	gSndPlayer.pos[0] = NULL;
	gSndPlayer.audio_len[0] = 0;

	gSndPlayer.buf[1] = NULL;
	gSndPlayer.pos[1] = NULL;
	gSndPlayer.audio_len[1] = 0;

	gSndOpened = TRUE;

	
	OGG_Init();

	//Mix_OpenAudio(MIX_DEFAULT_FREQUENCY,MIX_DEFAULT_FORMAT,1,4096);

	//currentWav=0;
 //   for(int i=0;i<WAVNUM;i++)
 //        WavChunk[i]=NULL;

	SDL_PauseAudio(0);

	return 0;
}


VOID SOUND_CloseAudio(VOID)
{

	atexit(SDL_CloseAudio);
	if (gSndPlayer.buf[0] != NULL)
	{
		free(gSndPlayer.buf[0]);
		gSndPlayer.buf[0] = NULL;
	}

	if (gSndPlayer.buf[1] != NULL)
	{
		free(gSndPlayer.buf[1]);
		gSndPlayer.buf[1] = NULL;
	}

	if (gSndPlayer.snd != NULL)
	{
		fclose(gSndPlayer.snd);
		gSndPlayer.snd = NULL;
	}

	atexit(OGG_Shutdown);
}


VOID SOUND_PlayChannel(INT iSoundNum,INT iChannel,INT iType)
{
	SDL_AudioCVT    wavecvt;
	SDL_AudioSpec   wavespec;
	Uint8           *buf;
	UINT            samplesize;
	Uint32             len = 0;

	if (!gSndOpened || g_fNoSound)
	{
	  return;
	}

	if (gSndPlayer.buf[iChannel] != NULL)
	{
		LPBYTE p = gSndPlayer.buf[iChannel];
		gSndPlayer.buf[iChannel] = NULL;
		free(p);
		p = NULL;
	}

	if (iSoundNum < 0)
	{
		return;
	}

	char cFile[256] = {0};
	if (iType == 0)
	{
		sprintf(cFile,"%s\\Resource\\sound\\Atk%02d.wav",JY_PREFIX,iSoundNum);
	}
	else
	{
		sprintf(cFile,"%s\\Resource\\sound\\E%02d.wav",JY_PREFIX,iSoundNum);
	}

	if (SDL_LoadWAV(cFile,&wavespec,&buf,&len) != NULL)
	{
		SDL_BuildAudioCVT(&wavecvt, wavespec.format, wavespec.channels, wavespec.freq,
                           AUDIO_S16,1,22050);
		wavecvt.buf = (Uint8 *)malloc(len*wavecvt.len_mult);
		memcpy(wavecvt.buf, buf, len);
        wavecvt.len = len;
        SDL_ConvertAudio(&wavecvt);
        SDL_FreeWAV(buf);
		SDL_LockAudio();
		gSndPlayer.buf[iChannel] = wavecvt.buf;
		gSndPlayer.audio_len[iChannel] = wavecvt.len_cvt;
		gSndPlayer.pos[iChannel] = wavecvt.buf;
		SDL_UnlockAudio();
	}
	else//不支持中文路径
	{
		FILE *fp = NULL;
		fp = fopen(cFile,"rb");
		if (fp == NULL)
		{
			return;
		}
		LPBYTE pSoundbuf = NULL;
		INT iLen = 0;
		fseek(fp, 0, SEEK_END);
		iLen = ftell(fp);
		fseek(fp, 0, SEEK_SET);
		pSoundbuf = (LPBYTE)malloc(iLen);
		if (pSoundbuf == NULL)
		{
			return;
		}
		iLen = fread(pSoundbuf, 1, iLen, fp);
		fclose(fp);
		fp=NULL;

		SDL_RWops *pRwop = SDL_RWFromMem((void*)pSoundbuf,iLen);
		if (pRwop == NULL)
		{
			SafeFree(pSoundbuf);
			return;
		}
		if (SDL_LoadWAV_RW(pRwop,1,&wavespec,&buf,&len) == NULL)
		{
			SafeFree(pSoundbuf);
			SafeFree(pRwop);
			return;
		}

		SDL_BuildAudioCVT(&wavecvt, wavespec.format, wavespec.channels, wavespec.freq,
                           AUDIO_S16,1,22050);
		wavecvt.buf = (Uint8 *)malloc(len*wavecvt.len_mult);
		memcpy(wavecvt.buf, buf, len);
        wavecvt.len = len;
        SDL_ConvertAudio(&wavecvt);
        SDL_FreeWAV(buf);
		SDL_LockAudio();
		gSndPlayer.buf[iChannel] = wavecvt.buf;
		gSndPlayer.audio_len[iChannel] = wavecvt.len_cvt;
		gSndPlayer.pos[iChannel] = wavecvt.buf;
		SDL_UnlockAudio();

	}

}
