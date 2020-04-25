#include "main.h"
#include "../ogg/ivorbiscodec.h"
#include "../ogg/ivorbisfile.h"

extern "C"
{
	extern BOOL g_fNoMusic;
	//BOOL GetIniValue(char* file, char* session, char* key, char*defvalue, char* value);
};

typedef struct tagOGGPLAYER
{
   tagOGGPLAYER() : /*opl(22050, true, false), rix(&opl), */iCurrentMusic(-1) {}
   //CEmuopl                    opl;
   //CrixPlayer                 rix;
   BOOL						  bReaded;
   OggVorbis_File			  m_oggf;
   INT                        iCurrentMusic; // current playing music number
   INT                        iNextMusic; // the next music number to switch to
   DWORD                      dwStartFadeTime;
   DWORD                      dwEndFadeTime;
   enum { FADE_IN, FADE_OUT } FadeType; // fade in or fade out ?
   BOOL                       fLoop;
  // BYTE                       buf[4096];
   char	 					  OggPath[256];
   int						  sample;
   LPBYTE                     pos;
} OGGPLAYER, *LPOGGPLAYER;

static LPOGGPLAYER gpOggPlayer = NULL;

VOID OGG_FillBuffer(LPBYTE stream,INT len)
{

   INT       i, l=0,  volume = SDL_MIX_MAXVOLUME, current_section, rlen=len;
   UINT      t = SDL_GetTicks();

   if (gpOggPlayer == NULL || !gpOggPlayer->bReaded )
   {
      //
      // Not initialized
      //
      return;
   }

   //
   // fading in or fading out
   //
   
   //if (gpOggPlayer->dwEndFadeTime > 0)
   //{
   //   switch (gpOggPlayer->FadeType)
   //   {
   //   case RIXPLAYER::FADE_IN:
   //      if (t >= gpOggPlayer->dwEndFadeTime)
   //      {
   //         gpOggPlayer->dwEndFadeTime = 0;
   //      }
   //      else
   //      {
   //         volume = (INT)(volume * (t - gpOggPlayer->dwStartFadeTime) /
   //            (FLOAT)(gpOggPlayer->dwEndFadeTime - gpOggPlayer->dwStartFadeTime));
   //      }
   //      break;

   //   case RIXPLAYER::FADE_OUT:
   //      if (gpOggPlayer->iCurrentMusic == -1)
   //      {
   //         //
   //         // There is no current playing music. Just start playing the next one.
   //         //
   //         gpOggPlayer->iCurrentMusic = gpOggPlayer->iNextMusic;
   //         gpOggPlayer->FadeType = RIXPLAYER::FADE_IN;
   //         gpOggPlayer->dwEndFadeTime = t +
   //            (gpOggPlayer->dwEndFadeTime - gpOggPlayer->dwStartFadeTime);
   //         gpOggPlayer->dwStartFadeTime = t;
   //         ov_time_seek(&(gpOggPlayer->m_oggf), 0);//gpOggPlayer->rix.rewind(gpOggPlayer->iCurrentMusic);
   //         return;
   //      }
   //      else if (t >= gpOggPlayer->dwEndFadeTime)
   //      {
   //         if (gpOggPlayer->iNextMusic <= 0)
   //         {
   //            gpOggPlayer->iCurrentMusic = -1;
   //            gpOggPlayer->dwEndFadeTime = 0;
   //         }
   //         else
   //         {
   //            //
   //            // Fade to the next music
   //            //
   //            gpOggPlayer->iCurrentMusic = gpOggPlayer->iNextMusic;
   //            gpOggPlayer->FadeType = RIXPLAYER::FADE_IN;
   //            gpOggPlayer->dwEndFadeTime = t +
   //               (gpOggPlayer->dwEndFadeTime - gpOggPlayer->dwStartFadeTime);
   //            gpOggPlayer->dwStartFadeTime = t;
   //            ov_time_seek(&(gpOggPlayer->m_oggf), 0);// gpOggPlayer->rix.rewind(gpOggPlayer->iCurrentMusic);
   //         }
   //         return;
   //      }
   //      volume = (INT)(volume * (1.0f - (t - gpOggPlayer->dwStartFadeTime) /
   //         (FLOAT)(gpOggPlayer->dwEndFadeTime - gpOggPlayer->dwStartFadeTime)));
   //      break;
   //   }
   //}

   if (gpOggPlayer->iCurrentMusic <= 0)
   {
      //
      // No current playing music
      //
      return;
   }

   //if (gpOggPlayer->sample != 22050)
	  // rlen = len*(gpOggPlayer->sample/22050.f);

   while(l < len)
   {
	   if (!(i = ov_read(&(gpOggPlayer->m_oggf), stream+l, 16
		   , &current_section))) break;
	   l += i;
   }

   if (!i)
   {
	   if (gpOggPlayer->fLoop>0) 
		   --gpOggPlayer->fLoop;
	   
	   if (gpOggPlayer->fLoop == 0)
	   {
		   gpOggPlayer->iCurrentMusic = -1;
	   }
	   else
	   {
		   ov_time_seek(&(gpOggPlayer->m_oggf), 0);
	   }

	   return;
   }
}

INT OGG_Init(VOID)
{
   gpOggPlayer = new OGGPLAYER;
   if (gpOggPlayer == NULL)
   {
      return -1;
   }
	LPSTR cFile = NULL;
	cFile = va("%s%s", JY_PREFIX, "\\Resource\\sound");
   strcpy(gpOggPlayer->OggPath,cFile );
	SafeFree(cFile);
   gpOggPlayer->bReaded = FALSE;
   gpOggPlayer->iCurrentMusic = -1;
   gpOggPlayer->dwEndFadeTime = 0;
   gpOggPlayer->pos = NULL;

   return 0;
}

VOID OGG_Shutdown(VOID)
{

   if (gpOggPlayer != NULL)
   {
	   if (gpOggPlayer->bReaded)
	   {
		   whole_mem_file* wf = (whole_mem_file*)(gpOggPlayer->m_oggf.datasource);
		   delete [] (BYTE*)(wf->data);
		   delete wf;
		   ov_clear(&(gpOggPlayer->m_oggf));
		    gpOggPlayer->bReaded = FALSE;
	   }

      delete gpOggPlayer;
      gpOggPlayer = NULL;
   }
}

VOID OGG_Play(INT iNumOGG,INT iFloopTimes)
{
	
   if (iNumOGG < 0)
	   return;

   if (gpOggPlayer == NULL)
   {
      return;
   }

   DWORD t = SDL_GetTicks();
   gpOggPlayer->fLoop = (iFloopTimes == FALSE ? 1 : -1);

   if (iNumOGG == gpOggPlayer->iCurrentMusic && !g_fNoMusic)
   {
      return;
   }

   if (gpOggPlayer->bReaded)
   {
	   whole_mem_file* wf = (whole_mem_file*)(gpOggPlayer->m_oggf.datasource);
	   delete [] (BYTE*)(wf->data);
	   delete wf;
	   ov_clear(&(gpOggPlayer->m_oggf));
	   gpOggPlayer->bReaded = FALSE;
   }

   if (iNumOGG > 0)
   {
	   char *pBuf = NULL;
	   pBuf = va("%s\\game%02d.ogg",gpOggPlayer->OggPath, iNumOGG);
	   FILE* fp = NULL;
	   fp = fopen(pBuf, "rb");
	   SafeFree(pBuf);
	   if (fp)
	   {
		   fseek(fp, 0, SEEK_END);
		   int n = ftell(fp);
		   fseek(fp, 0, SEEK_SET);

		   whole_mem_file* m = new whole_mem_file;// new char[sizeof(whole_mem_file)+n-1];
		   m->data = new BYTE[n];
		   m->mem_size = n;
		   m->curr_pos = 0;
		   fread(m->data, 1, n, fp);
		   fclose(fp);
		   fp = 0;

		   if(ov_open_mem(m, &(gpOggPlayer->m_oggf), NULL, 0) < 0) 
		   {
			   return;	
		   }
		   vorbis_info *vi = ov_info(&(gpOggPlayer->m_oggf), -1);
		   gpOggPlayer->sample = vi->rate;
		   gpOggPlayer->iCurrentMusic = iNumOGG;
		   gpOggPlayer->bReaded = TRUE;

	   }
   }

   gpOggPlayer->iNextMusic = iNumOGG;
   gpOggPlayer->dwStartFadeTime = 0;//t;
   gpOggPlayer->FadeType = OGGPLAYER::FADE_OUT;
}
