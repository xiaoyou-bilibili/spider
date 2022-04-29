library(httr)
library(stringr)

# 发送get请求
get <- function(url) {
    # 发送http请求
    r <- httr::GET(url)
    # 获取返回的body
    content <- content(r,"text")
    # 返回结果
    return(content)
}

# 获取文章内容
getContent <- function(url){
    res <- get(url)
    # 正则匹配内容
    content <- str_extract(res,"showtxt\">([\\s\\S]*?)</div>")
    # 替换掉无用的字符串
    content <- str_replace_all(content,"showtxt\">","")
    content <- str_replace_all(content,"</div>","")
    content <- str_replace_all(content,"<br />","\n")
    content <- str_replace_all(content,"&nbsp;","")

    return(content)
}

# 获取所有章节
getAllChapter <- function(){
    content <- get("http://www.qiushuge.net/zhongjidouluo/")
    # 对内容进行匹配
    finds <- str_extract_all(content,"<dd><a href =\"(.*?)\">(.*?)</a></dd>")
    # 写入文件
    fout <- file("content.txt","w")
    # 遍历我们的数组,这里我们使用unlist把列表转换为向量
    for (c in unlist(finds)){
        # 替换到文章的url链接，这里使用正则匹配内容，然后再对字符串进行裁剪
        href <- str_sub(str_extract(c,"\"(.*?)\""), 2, -2)
        # 这里就是把字符串拼接起来sep表示风隔符
        href <- paste("http://www.qiushuge.net",href,sep="")
        # 获取标题信息
        title <- str_sub(str_extract(c,"\">(.*?)</a>"), 3, -5)
        print(paste("正在下载", title))
        # 下载对应章节
        content <- getContent(href)
        # 写入我们的标题
        writeLines(paste("\n\n",title,"\n\n"), fout)
        # 写入我们的内容
        writeLines(content,fout)
    }
    # 关闭文件
    close(fout)
}


getAllChapter()

