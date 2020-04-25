// ConsoleApplication1.cpp: 定义控制台应用程序的入口点。
//

#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#ifdef _WIN32
#include <shlwapi.h>
#endif
#include "File.h"
#include "convert.h"
#include "opencv2/opencv.hpp"
#include <io.h>

using namespace std;

int getFileLength(const string& filepath)
{
    FILE* file = fopen(filepath.c_str(), "rb");
    if (file)
    {
        int size = filelength(fileno(file));
        fclose(file);
        return size;
    }
    return 0;
}

int getFileRecord(const string& filepath)
{
    auto buffer = File::readFile(filepath.c_str());
    int fileLength = buffer.size();
    int size = *(int*)(buffer.data() + fileLength - 4);
    return size;
}

void copyFile(std::string file1, std::string file2)
{
#ifdef _WIN32
    CopyFileA(file1.c_str(), file2.c_str(), FALSE);
#else
    char buf[BUFSIZ];
    size_t size;

    FILE* source = fopen(file1.c_str(), "rb");
    FILE* dest = fopen(file2.c_str(), "wb");

    // clean and more secure
    // feof(FILE* stream) returns non-zero if the end of file indicator for stream is set

    while (size = fread(buf, 1, BUFSIZ, source))
    {
        fwrite(buf, 1, size, dest);
    }

    fclose(source);
    fclose(dest);
#endif
}

int pair_grp_idx(string pathgrp, string pathidx)
{
    vector<string> grps, idxs;

    struct grpidx
    {
        std::string grpname;
        int record;
    };

    std::vector<grpidx> gggg;
    grps = File::getFilesInPath(pathgrp);
    for (auto grp : grps)
    {
        auto grp0 = pathgrp + grp;
        //printf("%s, %d\n", grp.c_str(), getFileLength(grp0));
        gggg.push_back({ grp0, getFileLength(grp0) });
    }

    idxs = File::getFilesInPath(pathidx);
    for (auto idx : idxs)
    {
        auto idx0 = pathidx + idx;
        //printf("%s, %d\n", idx.c_str(), getFileRecord(idx0));
        for (auto& gi : gggg)
        {
            if (getFileRecord(idx0) == gi.record)
            {
                //printf("find %s\n", gi.grpname.c_str());
                copyFile(idx0, File::changeFileExt(gi.grpname, "idx"));
            }
        }
    }
    return 0;
}

int convert_grpidx_to_png()
{
    auto col = File::readFile("mmap.col");
    string offset;
    for (int n = 0; n < 999; n++)
    {
        auto filename = convert::formatString("fight%03d.idx", n);
        if (File::fileExist(filename))
        {
            vector<int> idx;
            File::readFileToVector(filename, idx);
            idx.insert(idx.begin(), 0);
            auto grp = File::readFile(File::changeFileExt(filename, "grp"));

            printf("Found %s, %d images\n", filename.c_str(), idx.size() - 1);

            for (int m = 0; m < idx.size() - 1; m++)
            {
                int w = *(short*)&grp[idx[m] + 0];
                int h = *(short*)&grp[idx[m] + 2];
                int xoff = *(short*)&grp[idx[m] + 4];
                int yoff = *(short*)&grp[idx[m] + 6];

                if (w > 255 || h > 255)
                {
                    continue;
                }

                cv::Mat image(h, w, CV_8UC4);
                image = 0;

                int p = 0;
                unsigned char* data = (unsigned char*)&grp[idx[m] + 8];
                int datalong = idx[m + 1] - idx[m];
                for (int i = 0; i < h; i++)
                {
                    int yoffset = i * w;
                    unsigned int row = data[p];    // i行数据个数
                    int start = p;
                    p++;
                    if (row > 0)
                    {
                        int x = 0;    // i行目前列
                        for (;;)
                        {
                            x = x + data[p];    // i行空白点个数，跳个透明点
                            if (x >= w)         // i行宽度到头，结束
                            {
                                break;
                            }
                            p++;
                            int solidnum = data[p];    // 不透明点个数
                            p++;
                            for (int j = 0; j < solidnum; j++)
                            {
                                //data32[yoffset + x] = m_color32[data[p]] | AMASK;
                                image.at<uint32_t>(yoffset + x) = 0xffffffff;
                                char* pixel = (char*)&(image.at<uint32_t>(yoffset + x));
                                unsigned char index = data[p];
                                *(pixel + 0) = 4 * col[3 * index + 2];
                                *(pixel + 1) = 4 * col[3 * index + 1];
                                *(pixel + 2) = 4 * col[3 * index + 0];
                                p++;
                                x++;
                            }
                            if (x >= w)
                            {
                                break;
                            }    // i行宽度到头，结束
                            if (p - start >= row)
                            {
                                break;
                            }    // i行没有数据，结束
                        }
                        if (p + 1 >= datalong)
                        {
                            break;
                        }
                    }
                }
                string path = "人物" + std::to_string(n) + "第" + std::to_string(m) + "帧.png";
                cv::imwrite(path, image);
                offset += convert::formatString("ID %d Frame %d, Xoff: %d Yoff %d\n", n, m, xoff, yoff);
                //fout << "ID" << std::to_string(n) << " Frame" << std::to_string(m) << ", Xoff: " << x << " Yoff: " << y << "\n" << endl;
            }
        }
    }
    convert::writeStringToFile(offset, "offset.txt");
    return 0;
}