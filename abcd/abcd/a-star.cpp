// ConsoleApplication1.cpp: 定义控制台应用程序的入口点。
//
#include "cstdint"
#include "string"

// 0923.cpp: 定义控制台应用程序的入口点。
#include <iostream>
#include <condition_variable>
#include <thread>
#include <chrono>
#include <sstream>
#include <queue>
#include <atomic>

struct Point
{
public:
    Point() {}
    Point(int _x, int _y) : x(_x), y(_y) {}
    ~Point() {}
    int x = 0, y = 0;
};

typedef int16_t SAVE_INT;
typedef uint16_t SAVE_UINT;

struct MapSquare
{
    MapSquare() {}
    ~MapSquare() { if (data_) { delete data_; } }
    //不会保留原始数据
    void resize(int x)
    {
        if (data_) { delete data_; }
        data_ = new SAVE_INT[x * x];
        line_ = x;
    }

    SAVE_INT& data(int x, int y) { return data_[x + line_ * y]; }
    SAVE_INT& data(int x) { return data_[x]; }
    int size() { return line_ * line_; }
    void setAll(int v) { for (int i = 0; i < size(); i++) { data_[i] = v; } }
private:
    SAVE_INT * data_ = nullptr;
    SAVE_INT line_ = 0;
};

int pppp()
{
    MapSquare select_layer_;
    select_layer_.resize(64);
    select_layer_.setAll(-1);
    Point p0(32, 32);
    std::vector<Point> cal_stack;
    cal_stack.push_back(p0);
    int step = 15;
    while (step >= 0)
    {
        std::vector<Point> cal_stack_next;
        for (auto p : cal_stack)
        {
            select_layer_.data(p.x, p.y) = step;
            auto check_push = [&](Point p1)->void
            {
                if (select_layer_.data(p1.x, p1.y) == -1)
                {
                    cal_stack_next.push_back(p1);
                }
            };
            check_push({ p.x - 1, p.y });
            check_push({ p.x + 1, p.y });
            check_push({ p.x, p.y - 1 });
            check_push({ p.x, p.y + 1 });
        }
        cal_stack = cal_stack_next;
        step--;
    }

    for (int ix = 0; ix < 64; ix++)
    {
        for (int iy = 0; iy < 64; iy++)
        {
            printf("%4d", select_layer_.data(ix, iy));
        }
        printf("\n");
    }
    return 0;
}

int a_star()
{
    int max_step = 64;
    MapSquare* distance_layer_ = new MapSquare();
    distance_layer_->resize(64);
    distance_layer_->setAll(64);
    distance_layer_->setAll(64);
    std::vector<Point> cal_stack;
    cal_stack.push_back({ 31, 31 });
    int count = 0;
    int step = 0;
    while (step < 64)
    {
        std::vector<Point> cal_stack_next;
        auto check_next = [&](Point p1)->void
        {
            //未计算过且可以走的格子参与下一步的计算
            if (p1.x >= 0 && p1.x < 64 && p1.y >= 0 && p1.y < 64 && distance_layer_->data(p1.x, p1.y) == 64)
            {
                distance_layer_->data(p1.x, p1.y) = step + 1;
                cal_stack_next.push_back(p1);
                count++;
            }
        };
        for (auto p : cal_stack)
        {
            check_next({ p.x - 1, p.y });
            check_next({ p.x + 1, p.y });
            check_next({ p.x, p.y - 1 });
            check_next({ p.x, p.y + 1 });
            if (count >= 4096) { break; }  //最多计算次数，避免死掉
        }
        if (cal_stack_next.size() == 0) { break; }  //无新的点，结束
        cal_stack = cal_stack_next;
        step++;
    }
    for (int ix = 0; ix < 64; ix++)
    {
        for (int iy = 0; iy < 64; iy++)
        {
            printf("%4d", distance_layer_->data(ix, iy));
        }
        printf("\n");
    }
    return 0;
}
