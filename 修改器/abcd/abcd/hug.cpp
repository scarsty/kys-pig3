#include <cmath>
#include <cstdio>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>
#include <algorithm>
#include "File.h"
#include "convert.h"
#include <windows.h>
#include <corecrt_io.h>
#include <direct.h>
#include "opencv2/opencv.hpp"

using namespace std;

static void copyFile(std::string file1, std::string file2)
{
    if (file1.empty() || file2.empty())
    {
        return;
    }
#ifdef _WIN32
    CopyFileA(file1.c_str(), file2.c_str(), FALSE);
#else
    //不知咋弄，先不要了
    //char buf[BUFSIZ];
    //size_t size;

    //FILE* source = fopen(file1.c_str(), "rb");
    //FILE* dest = fopen(file2.c_str(), "wb");

    //// clean and more secure
    //// feof(FILE* stream) returns non-zero if the end of file indicator for stream is set

    //while (size = fread(buf, 1, BUFSIZ, source))
    //{
    //    fwrite(buf, 1, size, dest);
    //}

    //fclose(source);
    //fclose(dest);
#endif
}

void mkdir(std::string pathname)
{
    if (access(pathname.c_str(), 0))
    {
        _mkdir(pathname.c_str());
    }
}

bool compare_filenames( std::string a,  std::string b)
{
    int a1 = atoi(convert::findANumber(a).c_str());
    int b1 =  atoi(convert::findANumber(b).c_str());
    return a1 < b1;
}

int mainrfff()
{
    string workpath = R"(C:\Users\sty\Desktop\fight\new)";
    for (int i = 0; i < 1200; i++)
    {
        int k = 0;
        string ka;
        string fftxt;
        string path0 = convert::formatString((workpath + "\\fight%04d\\").c_str(), i);
        string path1 = convert::formatString((workpath + "1\\fight%04d\\").c_str(), i);
        for (int j = 0; j < 10; j++)
        {
            string path = convert::formatString((workpath + "\\fight%04d\\%02d\\").c_str(), i, j);
            if (File::fileExist(path + "index.ka"))
            {
                mkdir(path1);
                auto kathis = convert::readStringFromFile(path + "index.ka");
                ka += kathis;
                fftxt += convert::formatString("%d, %d\r\n", j, kathis.size() / 4 / 4);
                auto files = File::getFilesInPath(path, 0, 0);
                std::sort(files.begin(), files.end(), compare_filenames);
                for (auto f : files)
                {
                    if (File::getFileExt(f) != "png")
                    {
                        continue;
                    }
                    copyFile(path + f, path1 + convert::formatString("%d.png", k));
                    k++;
                }
            }
        }
        convert::writeStringToFile(ka, path1 + "index.ka");
        convert::writeStringToFile(fftxt, path1 + "fightframe.txt");
    }
    return 0;
}

int main()
{
    string path = R"(C:\Users\sty\Desktop\eft\eft235\)";
    auto files = File::getFilesInPath(path,1);
    for (auto f : files)
    {
        if (File::getFileExt(f) != "png")
        {
            continue;
        }
        cv::Mat img = cv::imread(path+f,-1);
        std::vector<cv::Mat> chs;
        cv::split(img, chs);

        cv::Mat alpha;
        if (chs.size() == 4)
        {
            alpha = chs[3];
            if (alpha.at<uint8_t>(0, 0) == 0)
            {
                //continue;
            }
        }
        else
        {
            alpha = cv::Mat::zeros(img.rows, img.cols, CV_8UC1);
            chs.push_back(alpha);
        }
        printf("%s\n", f.c_str());
        for (int ir = 0; ir < img.rows; ir++)
        {
            for (int ic = 0; ic < img.cols; ic++)
            {
                uint8_t* v;
                if (img.channels() == 4)
                {
                    v = (uint8_t*)&img.at<cv::Vec4b>(ir, ic);
                }
                else
                {
                    v = (uint8_t*)&img.at<cv::Vec3b>(ir, ic);
                }
                //if (v != cv::Vec3b(0, 0, 0))
                {
                    int v1 = (v[0] + v[1] + v[2]) / 1.5;
                    if (v1 > 255) v1 = 255;
                    alpha.at<uint8_t>(ir, ic) =v1 ;
                }
            }
        }
        //chs.push_back(alpha);
        cv::merge(chs,alpha);
        cv::imwrite(path+f, alpha);
    }
    return 0;
}