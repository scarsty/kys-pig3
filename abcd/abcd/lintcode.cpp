#include <cmath>
#include <cstdio>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int _393()
{
    int K = 2;
    std::vector<int> prices = { 4, 4, 6, 1, 1, 4, 2, 5 };

    if (prices.size() <= 1) return 0;
    int sum = 0;
    int ppp = 0;
    std::vector<int> zhuan;
    std::vector<int> p2;
    int in = -1;
    if (prices[0] < prices[1])
    {
        p2.push_back(-prices[0]);
        in = 1;
    }
    for (int i = 1; i < prices.size() - 1; i++)
    {
        if (in == -1 && prices[i] <= prices[i - 1] && prices[i] < prices[i + 1])
        {
            p2.push_back(-prices[i]);
            in = 1;
        }
        if (in == 1 && prices[i] >= prices[i - 1] && prices[i] > prices[i + 1])
        {
            p2.push_back(prices[i]);
            in = -1;
        }
    }
    if (in == 1 && prices[prices.size() - 2] <= prices.back())
    {
        p2.push_back(prices.back());
        in = -1;
    }
    int n = p2.size() / 2;
    for (int in = 0; in < n - K; in++)
    {
        int min = 999999;
        int index = 0;
        for (int i = 0; i < p2.size() - 1; i++)
        {
            int m = p2[i] + p2[i + 1];
            if (m < min)
            {
                min = m;
                index = i;
            }
        }
        p2.erase(p2.begin() + index, p2.begin() + index + 2);
    }
    sum = std::accumulate(p2.begin(), p2.end(), 0);
    if (sum <= 0)
    {
        return 0;
    }
    return sum;
}

int _202(int n)
{
    const int square[] = { 0,1,4,9,16,25,36,49,64,81 };
    int count[10] = { 0 };
    //int sum;   
    while (true)
    {
        int sum = 0;
        while (n > 0)
        {
            sum += square[n % 10];
            n /= 10;
        }
        n = sum;
        if (n < 10)
        {
            count[n]++;
            if (count[n] >= 2)
            {
                return n == 1;
            }
        }
    }
}

struct _53_s
{
    int l, m, r;
};

_53_s _53_sub(std::vector<int>& nums, int p, int l)
{
    if (l == 0)
    {
        return { 0,0,0 };
    }
    if (l == 1)
    {
        return { nums[p],nums[p],nums[p] };
    }
    int split = l / 2;
    auto sl = _53_sub(nums, p, split);
    auto sr = _53_sub(nums, p + split, l - split);
    _53_s s{ sl.l,sl.m + sl.r + sr.l + sr.m,sr.r };
    if (sl.m > s.m) s = { sl.l, sl.m,sl.r + sr.l + sr.m + sr.r };
    if (sr.m > s.m) s = { sr.l + sl.l + sl.m + sl.r ,sr.m,sr.r };
    return s;
}

int _53()
{
    std::vector<int> nums = { -2,1,-3,4,-1,2,1,-5,4 };
    return _53_sub(nums, 0, nums.size()).m;
}


string _168(int n)
{
    string ret;
    n = n - 1;
    while (n >= 0)
    {
        ret = char('A' + n % 26) + ret;
        n = n / 26 - 1;
    }
    return ret;
}

