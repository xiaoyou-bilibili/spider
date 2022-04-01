package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"regexp"
	"strings"

	"golang.org/x/text/encoding/simplifiedchinese"
	"golang.org/x/text/transform"
)

// GBK 转 UTF-8
// 参考：https://pkg.go.dev/golang.org/x/text@v0.3.7#section-readme
func GbkToUtf8(s []byte) ([]byte, error) {
	reader := transform.NewReader(bytes.NewReader(s), simplifiedchinese.GBK.NewDecoder())
	d, e := ioutil.ReadAll(reader)
	if e != nil {
		return nil, e
	}
	return d, nil
}

// 发送GET请求
func Get(url string) string {
	client := &http.Client{}
	// 构建一个GET请求
	request, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return ""
	}
	// 发送请求信息
	resp, err := client.Do(request)
	if err != nil {
		return ""
	}
	defer resp.Body.Close()
	// 转换为byte流信息
	bytes, err := ioutil.ReadAll(resp.Body)
	// 进行编码转换
	target, err := GbkToUtf8(bytes)
	if err != nil {
		fmt.Println("编码转换失败！")
		return ""
	}
	// 把bytes转换为string流
	return string(target)
}

// 获取章节内容
func GetContent(url string) string {
	result := Get(url)
	// 这里同样使用正则来进行替换
	re, _ := regexp.Compile("showtxt\">([\\s\\S]*?)</div>")
	contens := re.FindAllStringSubmatch(result, -1)
	content := ""
	// 拼接字符串信息
	for _, v := range contens {
		content += v[1] + "\n"
	}
	// 最后替换掉不需要的字符串
	content = strings.Replace(content, "&nbsp;", "", -1)
	content = strings.Replace(content, "<br />", "\n", -1)
	return content
}

// 获取所有的章节信息
func GetAllcapter() {
	result := Get("http://www.qiushuge.net/zhongjidouluo/")

	// 使用正则进行匹配
	re, _ := regexp.Compile(`<dd><a href =\"(.*?)\"`)
	links := re.FindAllStringSubmatch(result, -1)
	re2, _ := regexp.Compile(`\">(.*?)</a></dd>`)
	names := re2.FindAllStringSubmatch(result, -1)

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
	for i := 0; i < len(names); i++ {
		_, err1 := w.WriteString(names[i][1] + "\n\n")
		_, err2 := w.WriteString(GetContent("http://www.qiushuge.net" + links[i][1]))
		if err1 == nil && err2 == nil {
			fmt.Println("下载" + names[i][1] + "成功！")
		}
	}
	// 把buffer更新到文件中
	w.Flush()
}

func main() {
	// 使用正则爬取
	GetAllcapter()
}
