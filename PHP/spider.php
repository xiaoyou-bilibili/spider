<?php
// 引入PHPquery选择器
include 'phpQuery/phpQuery.php';

// 发送get请求
function get($url)
{
    //初始化curl模块
    $ch = curl_init();
    //登录提交的地址
    curl_setopt($ch, CURLOPT_URL, $url);
    //这个很关键就是把获取到的数据以文件流的方式返回，而不是直接输出
    curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
    // 执行我们的请求
    $output=curl_exec($ch);
    //关闭连接
    curl_close($ch);
    // 编码转换，把GBK转换为UTF-8编码
    $output = iconv('GBK', 'UTF-8', $output);
    return $output;
}

// 获取章节内容
function getContent($url){
    $output = get($url);
    // 这里使用正则来进行演示
    preg_match_all('/showtxt\">([\\s\\S]*?)<\/div>/',$output,$arr);
    $content = "";
    // 如果匹配到了，我们取第一个即可
    if(count($arr) > 1){
        $content = $arr[1][0];
        // 替换掉不需要的内容
        $content = str_replace("&nbsp;","",$content);
        $content = str_replace("<br />","\n",$content);
    }
    return $content;
}

// 获取所有的章节信息
function GetAllcapter(){
    $output = get("http://www.qiushuge.net/zhongjidouluo/");
    // 解析文档
    phpQuery::newDocument($output);
    // 创建一个文件
    $file = fopen("content.txt","w") or die("无法打开文件");
    //获取文章页数
    foreach (pq(".listmain>dl>dd>a") as $e){
        echo "正在下载".pq($e)->text()."\n";
        # 写入标题
        fwrite($file,"\n\n".pq($e)->text()."\n\n");
        # 写入章节内容
        fwrite($file,getContent("http://www.qiushuge.net".pq($e)->attr('href')));
    }
    // 写完后关闭文件
    fclose($file);
}


GetAllcapter();