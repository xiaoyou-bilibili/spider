import scala.util.matching.Regex
import java.io._

// 发送get请求
def get(url: String):String = {
  // 获取原始字节数据
  val content = requests.get(url).contents
  // 使用GBK进行编码
  return new String(content,"GBK")
}


// 获取文章内容
def getContent(url:String):String = {
  val res = get(url)
  // 文章内容匹配
  val pattern = new Regex("showtxt\">([\\s\\S]*?)</div>")
  var content = (pattern findAllIn res).mkString("")
  // 替换掉不需要的字符
  content = content.replaceAll("&nbsp;", "")
  content = content.replaceAll("<br />", "\n")
  content = content.replaceAll("showtxt\">", "")
  content = content.replaceAll("</div>", "")
  return content
}


@main def spider: Unit = {
  var res = get("http://www.qiushuge.net/zhongjidouluo/")
  // 开始进行正则匹配
  val pattern = new Regex("<dd><a href =\"(.*?)\">(.*?)</a></dd>")
  // 打开文件
  val writer = new PrintWriter(new File("content.txt" ))
  // 遍历所有找到的内容
  for (find <- pattern.findAllMatchIn(res)){
    var url = s"http://www.qiushuge.net${find.group(1)}"
    var title = find.group(2)
    // 打印当前进度
    println(s"正在下载 ${title}")
    var content = getContent(url)
    // 写入文件
    writer.write(s"\n\n${title}\n\n")
    writer.write(content)
  }
  writer.close()
}
