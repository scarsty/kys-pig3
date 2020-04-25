
#include "main.h"


//读取文件全部数据
INT JY_FILEReadData(LPBYTE lpBuffer,FILE *fp)
{
	INT len = 0;
	fseek(fp, 0, SEEK_END);
	len = ftell(fp);
	fseek(fp, 0, SEEK_SET);	
	len = fread(lpBuffer, 1,len, fp);
	return len;
}
//读取文件块数
INT JY_IDXGetChunkCount(FILE *fp)
{
	INT iNumChunk = 0;
	if (fp == NULL)
	{
	  return 0;
	}
	fseek(fp, 0, SEEK_END);
	iNumChunk = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	iNumChunk = iNumChunk / 4;
	return iNumChunk;
}
//读取块信息（大小、偏移）
INT JY_IDXGetChunkBaseInfo(INT uiChunkNum,FILE *fp,INT *uiSize,INT *uiAddress)
{
	INT    uiOffset       = 0;
	INT    uiNextOffset   = 0;
	INT    uiChunkCount   = 0;
	if (uiChunkNum < 0)
	{
		return -1;
	}
	uiChunkCount = JY_IDXGetChunkCount(fp);
	if (uiChunkNum >= uiChunkCount)
	{
		return -1;
	}
	INT iSeek = 0;
	iSeek = (uiChunkNum -1) * 4;
	if (uiChunkNum > 0)
	{
		fseek(fp, iSeek, SEEK_SET);
		fread(&uiOffset, sizeof(INT), 1, fp);
		fread(&uiNextOffset, sizeof(INT), 1, fp);
	}
	else
	{
		fseek(fp, 0, SEEK_SET);
		fread(&uiNextOffset, sizeof(INT), 1, fp);
		uiOffset = 0;
	}
	uiOffset = SWAP32(uiOffset);
	uiNextOffset = SWAP32(uiNextOffset);
	
	if ((uiNextOffset - uiOffset) == 0)
	{
		*uiSize = 0;
		*uiAddress = uiOffset;
		return -1;
	}
	else
	{
		*uiSize = uiNextOffset - uiOffset;
		*uiAddress = uiOffset;
	}

	return 0;
}

//读取数据块
INT JY_GRPReadChunk(LPBYTE lpBuffer,INT uiBufferSize,INT uiChunkAddress,FILE *fp)
{
	INT     uiOffset       = 0;
	INT     uiNextOffset   = 0;
	INT     uiChunkCount	= 0;
	INT     uiChunkLen		= 0;

	if (lpBuffer == NULL || fp == NULL || uiBufferSize == 0 || uiChunkAddress < 0)
	{
		return -1;
	}
	UINT uiFileLen = 0;
	fseek(fp, 0, SEEK_END);
	uiFileLen = ftell(fp);

	if (uiChunkAddress + uiBufferSize > uiFileLen)
	{
		return -1;
	}

	fseek(fp, uiChunkAddress, SEEK_SET);
	fread(lpBuffer, uiBufferSize, 1, fp);

	return 0;
}

//得到文件长度
INT JY_GetFileLength(FILE *fp)
{
	INT iNumChunk = 0;
	fseek(fp, 0, SEEK_END);
	iNumChunk = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	return iNumChunk;
}