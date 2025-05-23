#include <cmath>
#include <cstdio>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>
#include <algorithm>

#include <windows.h>
#include <corecrt_io.h>
#include <direct.h>
#include <print>
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

void autocrop(cv::Mat& m)
{
    int minX = m.cols - 1;
    int minY = m.rows - 1;
    int maxX = 0;
    int maxY = 0;
    for (int i = 0; i < m.rows; i++)
    {
        for (int j = 0; j < m.cols; j++)
        {
            if (m.at<cv::Vec3b>(i, j)[0] != 0 || m.at<cv::Vec3b>(i, j)[1] != 0 || m.at<cv::Vec3b>(i, j)[2] != 0)
            {
                minX = std::min(minX, j);
                minY = std::min(minY, i);
                maxX = std::max(maxX, j);
                maxY = std::max(maxY, i);
            }
        }
    }
    cv::Rect rect(minX, minY, maxX - minX + 1, maxY - minY + 1);
    m = m(rect);
}



int main()
{
    cv::Mat m = cv::imread("map.bmp");
    autocrop(m);
    size_t size = 8;
    int width = m.cols / size;
    int height = m.rows / size;
    int k = 0;
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            cv::Mat m1 = m(cv::Rect(j * width, i * height, width, height));
            double minv, maxv;
            cv::minMaxLoc(m1, &minv, &maxv);
            if (minv != maxv)
            {
                cv::imwrite(std::format("{}.png", k), m1);
                std::print("{}: {},{}\n", k, minv, maxv);
            }
            k++;
        }
    }
    return 0;
}