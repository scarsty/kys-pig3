
#include "SimpleCC.h"
#include <functional>

std::string SimpleCC::conv(const std::string& src)
{
    struct Words
    {
        int length = 0;                  //替换前的字数
        std::string* value = nullptr;    //替换后的字
    };

    if (root_.children.empty())
    {
        return src;
    }

    auto translate = [&](const std::string& str, int begin) -> Words
    {
        auto* t = &root_;
        int end = begin;
        Words word;
        while (end < str.size())
        {
            int len = utf8length(str[end]);
            auto key = str.substr(end, len);
            if (t->children.contains(key))
            {
                end += len;
                //递归查找最长的词组，不可中断
                if (!t->children[key].value.empty())
                {
                    word = { end - begin, &t->children[key].value };
                }
                t = &t->children[key];
            }
            else
            {
                break;
            }
        }
        if (word.length == 0)
        {
            int len = utf8length(str[begin]);
            return { len, nullptr };
        }
        return word;
    };

    std::string dst;
    int i = 0;
    while (i < src.size())
    {
        int i1 = i;
        std::string str1;
        auto word = translate(src, i);
        if (word.value == nullptr)
        {
            dst += src.substr(i, word.length);
        }
        else
        {
            dst += *word.value;
        }
        i += word.length;
    }
    return dst;
}

int SimpleCC::init(std::vector<std::string> files)
{
    for (const auto& file : files)
    {
        FILE* fp = fopen(file.c_str(), "rb");
        if (!fp)
        {
            continue;
        }
        fseek(fp, 0, SEEK_END);
        int len = ftell(fp);
        std::string str;
        str.resize(len);
        fseek(fp, 0, SEEK_SET);
        fread(str.data(), 1, len, fp);
        fclose(fp);

        int i = 0;
        //must be utf-8 encoded chinese text
        while (i < str.size())
        {
            //转换前后分割符为\t，转换后如有多个结果分割符为空格（实际未使用）
            auto pos_space = str.find('\t', i);
            if (pos_space == std::string::npos)
            {
                break;
            }
            std::string key = str.substr(i, pos_space - i);
            auto pos_line = str.find_first_of("\r\n", pos_space + 1);
            if (pos_line == std::string::npos)
            {
                break;
            }
            std::string value = str.substr(pos_space + 1, pos_line - pos_space - 1);
            if (value.contains(' '))
            {
                value = value.substr(0, value.find(' '));
            }
            write(key, value);
            i = pos_line + 1;
        }
    }

    return 0;
}

void SimpleCC::write(const std::string& key, const std::string& value)
{
    std::function<void(const std::string&, const std::string&, Tire&)> write_key = [&](const std::string& key, const std::string& value, Tire& t)
    {
        int len = utf8length(key[0]);
        if (key.size() <= len)
        {
            t.children[key].value = value;
        }
        else
        {
            write_key(key.substr(len), value, t.children[key.substr(0, len)]);
        }
    };
    write_key(key, value, root_);
}

int SimpleCC::utf8length(const unsigned char c)
{
    if (c < 0x80)
    {
        return 1;    // 1 byte character
    }
    else if ((c & 0xE0) == 0xC0)
    {
        return 2;    // 2 byte character
    }
    else if ((c & 0xF0) == 0xE0)
    {
        return 3;    // 3 byte character
    }
    else if ((c & 0xF8) == 0xF0)
    {
        return 4;    // 4 byte character
    }
    return 1;    // Default to 1 byte if not recognized
}
