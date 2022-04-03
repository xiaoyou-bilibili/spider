# 定义两个临时文件用于编码转换
tmp="tmp.txt"
tmp2="tmp2.txt"
res="content.txt"
# 发送get请求
get(){
    #执行请求并获取结果，然后存入一个文件中
    curl -s $1 > $tmp
    #对结果进行编码转换，并存入第二个文件中
    iconv -f gbk -t UTF-8 -c "$tmp" > $tmp2
    # 读取转换后的文件，然后存入编码
    response=$(<"$tmp2")
}

# 获取章节内容
getContent(){
    # 执行函数
    get $1
    # 开始进行正则匹配。这里使用懒惰匹配似乎会有问题
    regex2='showtxt">(.*)<br /></div>'
    # 进行正则匹配
    [[ "$response" =~ $regex2 ]]
    content=${BASH_REMATCH[1]}
    # 替换掉无用的字符串
    content=${content//&nbsp;/}
    content=${content//<br \/>/}
    # 写入我们的结果 >> 表示追加内容
    echo $content >> $res
}

# 获取所有的章节信息
getChapter(){
    url="http://www.qiushuge.net/zhongjidouluo/"
    # 执行函数
    get $url
    # 开始进行正则匹配。这里使用懒惰匹配似乎会有问题
    regex='<dd><a href ="/zhongjidouluo/([0-9]+)/">([^<]*)</a>'
    # 获取内容
    contents="$response"
    # 下面这里我们使用while去不断进行匹配
    while [[ "$contents" =~ $regex ]]; do
        href=${BASH_REMATCH[1]}
        title=${BASH_REMATCH[2]}
        # 这里是截取字符串，就是把匹配到的去掉，这样下次循环的时候就可以匹配下一个了
        contents=${contents/"${BASH_REMATCH[0]}"/}
        echo "正在下载$title"
        echo -e >> $res
        # 写入标题和内容
        echo $title >> $res
        # 输出换行
        echo -e >> $res
        # 下载章节内容
        getContent "$url$href/"
    done
    # echo $content
}

# 先清空
echo "" > $res
getChapter
# 删除两个临时文件
rm $tmp
rm $tmp2