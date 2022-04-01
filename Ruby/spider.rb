# 引入url扩展
require 'open-uri'
require 'iconv'

# 发送get请求
def get(url)
    response=nil
    # 打开网页，do end等价于{},http是它的参数
    open(url) do |http|
        # 获取返回结果
        response=http.read
    end
    # 进行编码转换
    response = Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE", response)
    # ruby默认会返回最后一个语句的返回结果
    response[0]
end

# 获取章节内容
def GetContent(url)
    content = ""
    response = get(url)
    # << 用于字符串拼接
    response.scan(/showtxt\">([\s\S]*?)<\/div>/).each{|item| content=content<<item[0]}
    # 替换掉不需要的字符串
    content = content.gsub("&nbsp;", "")
    return content.gsub("<br />", "\n")
end

# 获取所有的章节
def GetAllCapter()
    url='http://www.qiushuge.net/zhongjidouluo/'
    response = get(url)
    # 打开一个文件，如果打开失败就返回
    aFile=File.new("content.txt","a")
    unless aFile
        return
    end
    # 获取所有链接和标题
    links=Array.new
    names=Array.new
    response.scan(/<dd><a href =\"(.*?)\"/).each{|item| links[links.length+1]=item[0]}
    response.scan(/\">(.*?)<\/a><\/dd>/).each{|item| names[names.length+1]=item[0]}
    # 打印长度to_s可以把int转换为string类型
    puts "总章节:"+names.length.to_s
    # 下面开始遍历数组
    (0...names.length).each do |i|
        # 如果发现名称或者链接为空，就先跳过(因为第0个默认是空的)
        # next相当于continue语句，unless相当于 if not
        next unless names[i]!=nil && links[i]!=nil
        puts "正在下载:"+names[i]
        # 写入章节
        aFile.syswrite("\n\n"<<names[i]<<"\n\n")
        # 写入章节内容
        aFile.syswrite(GetContent("http://www.qiushuge.net"+links[i]))
    end
    # 关闭文件
    aFile.close
end

GetAllCapter()