#ifndef _PICCACHE_H
#define _PICCACHE_H

#ifdef __cplusplus
extern "C"
{
#endif

// 定义使用的链表 
struct CacheNode{    //贴图cache链表节点
	SDL_Surface *s;               // 此贴图对应的表面
	INT xoff;                     // 贴图偏移
	INT yoff;
	INT id;                  //贴图编号
    INT fileid;              //贴图文件编号
    struct list_head list;        // 链表结构，linux.h中的list.h中定义
} ;
struct PicFileCache{   //贴图文件链表节点
	INT num;                    // 文件贴图个数
    INT *idx;                  // idx的内容
    struct CacheNode **pcache;  // 文件中所有的贴图对应的cache节点指针，为空则表示没有。
};

#define PIC_FILE_NUM 10   //缓存的贴图文件(idx/grp)个数
INT Init_Cache(VOID);
INT JY_PicInit(VOID);
INT JY_PicLoadFile(const char*filename, INT id);
INT JY_LoadPic(INT fileid, INT picid, INT x,INT y,INT flag,INT value);
SDL_Surface *LoadPic(INT fileid,INT picid, INT *xoffset,INT *yoffset);
INT JY_GetPicXY(INT fileid, INT picid, INT *w,INT *h);
SDL_Surface* CreatePicSurface32(unsigned char *data, INT w,INT h,INT datalong);

#ifdef __cplusplus
}
#endif

#endif