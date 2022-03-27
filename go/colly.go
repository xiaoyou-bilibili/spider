package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/gocolly/colly"
)

// 获取文章内容
func getChapterContent(c *colly.Collector, buf *bufio.Writer) {
	c.OnHTML("div[id='content']", func(e *colly.HTMLElement) {
		_, _ = buf.WriteString(e.Text)
	})
}

// 获取章节信息
func getChapterInfo(buf *bufio.Writer) {
	// 文章内容爬取
	content := colly.NewCollector()
	// 设置文章内容爬取
	getChapterContent(content, buf)

	// 爬取章节信息
	c := colly.NewCollector()
	// 访问列表信息
	c.OnHTML("div[class='listmain']", func(e *colly.HTMLElement) {
		e.ForEach("dd>a", func(i int, h *colly.HTMLElement) {
			// 获取所有的章节信息
			_, _ = buf.WriteString("\n\n" + h.Text + "\n\n")
			fmt.Println("正在下载", h.Text)
			// 访问章节
			content.Visit("http://www.qiushuge.net" + h.Attr("href"))
		})
	})
	c.Visit("http://www.qiushuge.net/zhongjidouluo/")
}

// 使用colly来爬取网站
func main() {
	// 创建一个文件
	fp, err := os.Create("content.txt")
	if err != nil {
		return
	}

	// 最后我们需要关闭文件流
	defer func() {
		if err := fp.Close(); err != nil {
			fmt.Println("关闭文件失败")
		}
	}()
	// 写入文件
	w := bufio.NewWriter(fp)
	// 获取章节信息
	getChapterInfo(w)
	// 把buffer更新到文件中
	w.Flush()

}
