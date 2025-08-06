#pragma once

#include <string>
#include <unordered_map>
#include <vector>

class SimpleCC
{
public:
    std::string conv(const std::string& src);

    int init(std::vector<std::string> files);

private:
    void write(const std::string& key, const std::string& value);
    struct Tire
    {
        std::string value;
        std::unordered_map<std::string, Tire> children;
    };
    Tire root_;

    static int utf8length(const unsigned char c);
};
