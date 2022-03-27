// 使用系统提供的各种包
using System.Text;
using System.Text.RegularExpressions;

namespace spider
{
    public class Program
    {
        private readonly static HttpClient _client = new();

        // 发送get请求获取内容
        public async static Task<string?> GetAsync(string url)
        {
            // 发送一个request请求
            var resp = await _client.GetAsync(url);
            // 失败时返回空
            if (resp.IsSuccessStatusCode is false)
            {
                return null;
            }
            // 注册扩展包(支持GBK编码)
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            using var memoryStream = new MemoryStream();
            // 直接把stram拷贝到MemoryStream
            // https://stackoverflow.com/questions/1080442/how-to-convert-an-stream-into-a-byte-in-c
            await resp.Content.CopyToAsync(memoryStream);
            var buffer = memoryStream.ToArray();
            // 这里我们需要提前使用GBK来进行解码，如果是 UTF8 可以使用 Encoding.UTF8
            var result = Encoding.GetEncoding("GBK").GetString(buffer, 0, buffer.Length);
            return result;
        }

        // 获取某一个章节的内容
        public async static Task<string?> GetContentAsync(string url)
        {
            var content = await GetAsync(url);
            if (content is null)
            {
                return null;
            }
            var result = "";
            //遍历我们查找的的结果
            foreach (Match match in Regex.Matches(content, "showtxt\">([\\s\\S]*?)</div>"))
            {
                result += match.Groups[1].Value;
            }
            // 替换掉无关的内容
            result = result.Replace("&nbsp;", "").Replace("<br />", "\n");
            return result;
        }

        // 获取所有章节信息
        public async static Task GetAllCapterAsync()
        {
            var chapters = await GetAsync("http://www.qiushuge.net/zhongjidouluo/");
            if (chapters is null)
            {
                Console.Error.WriteLine("获取失败，Chapters 为空");
                return;
            }
            var parrent1 = "<dd><a href =\"(.*?)\"";
            var parrent2 = "\">(.*?)</a></dd>";
            // 使用正则匹配一下内容
            var links = Regex.Matches(chapters, parrent1);
            var names = Regex.Matches(chapters, parrent2);
            // 打开一个文件
            var fileStream = new FileStream("content.txt", FileMode.Append);
            var sw = new StreamWriter(fileStream);
            for (int i = 0; i < links.Count; i++)
            {
                await sw.WriteAsync(names[i].Groups[1].Value + "\n\n");
                Console.WriteLine("正在下载" + names[i].Groups[1].Value);
                var contentUrl = "http://www.qiushuge.net" + links[i].Groups[1].Value;
                var content = await GetContentAsync(contentUrl);
                if (content is null)
                {
                    Console.Error.WriteLine($"获取失败，Content 为空，URL = {contentUrl}");
                    continue;
                }
                await sw.WriteLineAsync(content);
            }
            // 写入文件信息
            sw.Close();
            fileStream.Close();
        }

        // 主函数入口
        public async static Task Main()
        {
            await GetAllCapterAsync();
        }
    }
}
