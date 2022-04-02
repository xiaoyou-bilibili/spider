// extern crate regex;

use regex::Regex;
use std::io::Write;

// 发送GET请求
async fn get(url: &str) -> String{
    // rust异步有两种方式，第一种就是在await后面加上？表示故障时返回Err对象，另外一种为unwrap表示错误时直接panic
    return reqwest::get(url)
        .await
        .unwrap()
        .text()
        .await
        .unwrap();
}

// 获取章节内容
async fn get_content(url: &str) -> String{
    // 获取结果
    let data =get(url).await;
    // 获取匹配到的内容
    let re = Regex::new(r#"showtxt">(.*{1})</div>"#).unwrap();
    let m = re.captures(&data).unwrap();
    // 替换字符串(rust一个变量不能赋值两次,但是可以重复声明)
    let result = str::replace(&m[1], "&nbsp;", "");
    let result = str::replace(&result, "<br />", "\n");
    
    return result;
}

// 获取所有的章节
async fn get_chapter(){
    // 获取结果
    let data =get("http://www.qiushuge.net/zhongjidouluo/").await;
    // 我们创建一个文件
    let mut file = std::fs::File::create("content.txt").expect("create failed");
    // 初始化一个正则表达式
    let re = Regex::new(r#"<dd><a href ="(.*{1})">(.*{2})</a></dd>"#,).unwrap();

    // 遍历我们捕获的结果    
    for _cap in re.captures_iter(&data){
        println!("正在下载: {}", &_cap[2]);
        // 写入标题和文章内容
        let title = format!("\n\n{}\n\n",&_cap[2]);
        file.write_all(&title.as_bytes()).expect("write failed");
        let data = get_content(&format!("{}{}", "http://www.qiushuge.net",&_cap[1])).await;
        file.write_all(&data.as_bytes()).expect("write failed");
    }
    
}

// 主函数入口
// 这里我们使用了tokio，rust的异步编程库，因为我们这个是异步函数，所以必须要给主函数加上async关键词
// 而且需要加上#[tokio::main]标识
#[tokio::main]
async fn main() {
    // rust的打印使用 println! 这个在reusy叫做宏
    println!("开始爬取");
    // 异步等待函数执行
    get_chapter().await;
    // get_content("http://www.qiushuge.net/zhongjidouluo/451062/").await;
}