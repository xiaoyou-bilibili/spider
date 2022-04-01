-- 引入依赖
local http = require("socket.http")
local iconv = require("iconv")

-- lua编码转换，本质上还是使用了iconv包
function GbkToUtf8(text)
    local cd = iconv.new("utf-8" .. "//TRANSLIT", "gbk")
    local ostr, err = cd:iconv(text)
    if err ~= nil then
        print("编码错误，错误代码"+err)
        return ""
    end
    return ostr
end

-- 发送get请求
function Get(url)
    local body, code, headers, status = http.request(url)
    if code == 200 then
        -- 编码转换
        return GbkToUtf8(body)
    end
    return ""
end

-- 获取章节内容
function GetContent(url)
    local content = Get(url)
    -- 获取所章节链接和标题
    local data = content:match('showtxt">(.-)</div>')
    data = data:gsub("&nbsp;","")
    data = data:gsub("<br />","\n")
    return data
end

-- 获取所有的章节
function GetAllChapter(url)
    local content = Get(url)
    -- 打开一个文件
    local file = io.open("content.txt", "w")
    -- 获取所章节链接和标题
    for href,title in content:gmatch('<dd><a href ="/zhongjidouluo/([0-9]+)/">(.-)</a></dd>') do
        print("正在下载", title)
        file:write("\n\n"..title.."\n\n")
        file:write(GetContent(url..href))
    end
    -- 关闭文件
    file:close()
end

GetAllChapter("http://www.qiushuge.net/zhongjidouluo/")


-- 参考资料
-- https://www.junmajinlong.com/lua/lua_str_regex/
