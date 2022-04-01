# 使用网络请求包
use LWP::UserAgent;

# 全局变量标准（our）关键字、局部变量标准（my）关键字
# （local）关键字将全局变量临时借用为局部、（state）关键字将局部变量变得持久

# 发送GET请求
sub Get {
    # 获取我们传递的参数
    my ($url) = @_;
    # 初始化一个UserAgent对象
    my $ua = LWP::UserAgent->new();
    # 发送一个get请求
    my $response = $ua->get($url);
    if ($response->is_success) {
        # 获取我们最后的结果（这个是经过编码的）
        return $response->decoded_content;
    }
    return "";
}

# 获取文章内容
sub GetContent {
    # 获取我们传递的参数
    my ($url) = @_;
    my $content = Get($url);
    # 获取匹配到的内容
    $content =~ /showtxt\">([\s\S]*?)<\/div>/;
    # 替换掉多余的字符串
    $content = $1;
    $content =~ s/&nbsp;//g;
    $content =~ s/<br \/>/\n/g;
    # 不需要加return，可以直接返回
    $content;
}

# 获取所有的章节
sub GetAllChapter {
    my $url = "http://www.qiushuge.net/zhongjidouluo/";
    my $content = Get($url);
    # 打开文件 打开的同时会清空文件
    open $file, ">", "content.txt" or "打开文件失败\n";
    while($content =~ /<dd><a href =\"\/zhongjidouluo\/(.*?)\">(.*?)<\/a><\/dd>/g){
        print "downloading ","$2 \n";
        # 把字符串打印到文件中
        print $file "\n\n $2 \n\n";
        print $file GetContent($url.$1);
    }
    # 关闭文件
    close $file;
}

GetAllChapter();

# 参考资料
# https://www.runoob.com/perl/perl-tutorial.html
# https://blog.csdn.net/Henjay724/article/details/8457556