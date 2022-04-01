from operator import le
import requests
from lxml import etree

# 获取某个章节的内容
def get_content(url,f):
    # 异常处理
    try:
        # 爬取这个链接，然后设置超时为5s
        result = requests.get(url, timeout=5).text
        root  = etree.HTML(result)
        # 解析这个div里面的内容
        contents = root.xpath("//div[@id='content']/text()")
        # 我们一行一行的写入这些内容
        for content in contents:
            # 去掉一些相关的字符串
            content = str(content).replace("\xa0","")
            f.write(content+ "\n")
    except:
        pass

# 获取所有章节
def get_all_chapter():
    host = "http://www.qiushuge.net"
    url = host + '/zhongjidouluo'
    # 访问网页
    result = requests.get(url).text
    # 使用etree转换为解析对象
    root = etree.HTML(result)
    # 解析获取所有章节信息
    data = root.xpath("//div[@class='listmain']/dl/dd")
    # 打开文件
    with open("content.txt","a") as f:
        # 一个章节一个章节解析
        for chapter in data:
            # 获取url和文本信息
            title = chapter.xpath("a/text()")
            url = chapter.xpath("a/@href")
            if len(title) > 0 and len(url)>0:
                title = title[0]
                url = url[0]
                print("正在下载 %s" % title)
                # 写入标题
                f.write("\n\n%s\n\n" % title)
                # 写入内容
                get_content(host+url, f)




if __name__ == "__main__":
    get_all_chapter()