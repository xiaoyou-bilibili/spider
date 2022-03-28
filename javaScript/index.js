// 首先引入必要的依赖
const iconv = require("iconv-lite");
const axios = require("axios");
const cheerio = require('cheerio');
const fs = require("fs");

// 发送get请求
async function Get(url){
    // 请求获取数据
	var res = await axios.get(url, { responseType: "arraybuffer" })
    // 需要对数据进行编码
	return iconv.decode(res.data, "gb2312")
}

// 获取章节内容
async function getContent(url){
    let result = await Get(url)
    let re1 = new RegExp("showtxt\">([\\s\\S]*?)</div>", "g")
    let content=""
    let data
    // 查找所有匹配的内容
    while ((data = re1.exec(result)) != null) {
        content+=data[1];
    }
    // 替换掉不需要的字符串
    content = content.replace(/&nbsp;/g,"")
    content = content.replace(/<br \/>/g,"\n")
    return content
}

// 获取章节信息
async function getChapter(){
    let html = await Get("http://www.qiushuge.net/zhongjidouluo/")
    // 对html进行解析
    const $ = cheerio.load(html)
    // 所有的章节信息和url
    let infos = []
    // 遍历所有章节，并塞入数组中
    $('.listmain dd').each(function(i,e){
        const a = $(this).children('a')
        infos.push({
            "title": a.text(),
            "url": a.attr('href')
        })
    })
    // 重新遍历章节信息
    for(let i=0;i<infos.length;i++){
        console.log("正在下载：", infos[i]["title"])
        // 获取章节内容
        let data = await getContent("http://www.qiushuge.net"+infos[i]["url"])
        // 写入标题信息
        fs.writeFileSync('content.txt', "\n\n"+ infos[i]["title"] + "\n\n", {flag: 'a'});
        // 写入章节内容
        fs.writeFileSync('content.txt', data, {flag: 'a'});
    }
}

// 执行函数
getChapter()
