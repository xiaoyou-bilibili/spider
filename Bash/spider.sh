# 定义两个临时文件用于编码转换
tmp="tmp.txt"
tmp2="tmp2.txt"
# 发送get请求
get(){
    # #执行请求并获取结果，然后存入一个文件中
    # curl $1 > $tmp
    # #对结果进行编码转换，并存入第二个文件中
    # iconv -f gbk -t UTF-8 -c "$tmp" > $tmp2
    # 读取转换后的文件，然后存入编码
    response=$(<"$tmp2")
}


# 获取所有的章节信息
getChapter(){
    url="http://www.qiushuge.net/zhongjidouluo/"
    # 执行函数
    get $url
    # 开始进行正则匹配。这里使用懒惰匹配似乎会有问题
    regex='<dd><a href ="/zhongjidouluo/([0-9]+)/">([^<]*)</a>'
    # 下面这里我们使用while去不断进行匹配
    while [[ "$response" =~ $regex ]]; do
        action=${BASH_REMATCH[1]}
        title=${BASH_REMATCH[2]}
        echo $action
        echo $title
        # 这里是截取字符串，就是把匹配到的去掉，这样下次循环的时候就可以匹配下一个了
        response=${response/"${BASH_REMATCH[0]}"/}
    done
    # echo $content
}


getChapter
# 删除两个临时文件
# rm $tmp
# rm $tmp2