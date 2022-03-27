// 使用系统提供的各种包
using System;
using System.Net;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;

namespace spider
{
    class Program
    {
        // 发送get请求获取内容
        public static string Get(string url){
            string result="";
            // 发送一个request请求
            WebRequest request = WebRequest.Create(url);
            WebResponse resp = request.GetResponse();
            Stream stream=resp.GetResponseStream();
            // 注册扩展包(支持GBK编码)
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            try{
                using(var memoryStream = new MemoryStream())
                {
                    // 直接把stram拷贝到MemoryStream
                    // https://stackoverflow.com/questions/1080442/how-to-convert-an-stream-into-a-byte-in-c
                    stream.CopyTo(memoryStream);
                    byte[] buffer =  memoryStream.ToArray();
                    // 这里我们需要提前使用GBK来进行解码，如果是UTF8可以使用Encoding.UTF8
                    result = Encoding.GetEncoding("GBK").GetString(buffer, 0, buffer.Length);
                }
            }finally{
                stream.Close();
            }
            return result;
        }
        
        // 获取某一个章节的内容
        public static string Getcontent(string url){
            string content=Get(url);
            string result="";
            //遍历我们查找的的结果
            foreach(Match match in Regex.Matches(content,"showtxt\">([\\s\\S]*?)</div>"))
                result+=match.Groups[1].Value;
            // 替换掉无关的内容
            result = result.Replace("&nbsp;","");
            result = result.Replace("<br />","\n");
            return result;
        }

        // 获取所有章节信息
        public static void GetAllCapter(){
            string content=Get("http://www.qiushuge.net/zhongjidouluo/");
            string parrent1="<dd><a href =\"(.*?)\"";
            string parrent2="\">(.*?)</a></dd>";
            // 使用正则匹配一下内容
            MatchCollection links=Regex.Matches(content,parrent1);
            MatchCollection names=Regex.Matches(content,parrent2);
            // 打开一个文件
            FileStream fileStream=new FileStream("content.txt",FileMode.Append);
            StreamWriter sw=new StreamWriter(fileStream);
            for(int i=0;i<links.Count;i++){
                sw.Write(names[i].Groups[1].Value+"\n\n");
                Console.WriteLine("正在下载"+names[i].Groups[1].Value);
                sw.Write(Getcontent("http://www.qiushuge.net"+links[i].Groups[1].Value));
            }
            // 写入文件信息
            sw.Flush();
            sw.Close();
            fileStream.Close();
        }

        // 主函数入口
        static void Main(string[] args)
        {
            GetAllCapter();
        }
    }
}
