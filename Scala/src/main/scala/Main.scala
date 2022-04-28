
// 发送get请求
def get(url: String):String = {
  // 获取原始字节数据
  val content = requests.get(url).contents
  // 使用GBK进行编码
  return new String(content,"GBK")
}



@main def spider: Unit = {
  println(get("http://www.qiushuge.net/zhongjidouluo/"))
}
