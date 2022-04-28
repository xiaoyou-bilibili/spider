package spider

import okhttp3.*
import okio.IOException
import java.io.File
import java.io.FileWriter

private val client = OkHttpClient()

// 下载章节内容
fun getContent(url:String): String {
    // 构建请求
    val request = Request.Builder().url(url).build()
    //  发送请求获取数据
    client.newCall(request).execute().use { response: Response ->
        if (!response.isSuccessful) throw IOException("Unexpected code $response")
        val data = response.body!!.string()
        //  进行正则匹配获取所有匹配的内容
        val contentRegex = "showtxt\">([\\s\\S]*?)</div>".toRegex()
        // 这里我们把匹配到的内容直接转换为数组
        val contents = contentRegex.findAll(data).map {
            it.groupValues[1].replace("&nbsp;","").replace("<br />","\n")
        }.toList()
        // 我们直接返回第一个就可以了
        return contents[0]
    }
}


fun main(args: Array<String>) {
    // 初始化一个文件
    val file = FileWriter("content.txt",true)
    // 构建请求
    val request = Request.Builder().url("http://www.qiushuge.net/zhongjidouluo/").build()
    //  发送请求，异步请求
    client.newCall(request).enqueue(object :Callback{
        override fun onFailure(call: Call, e: java.io.IOException) {
            e.printStackTrace()
        }

        override fun onResponse(call: Call, response: Response) {
            val data = response.body!!.string()
            //  进行正则匹配获取所有匹配的内容
            val hrefRegex = "<dd><a href =\"(.*?)\"".toRegex()
            val titleRegex = "\">(.*?)</a></dd>".toRegex()
            // 这里我们把匹配到的内容直接转换为数组
            val hrefs = hrefRegex.findAll(data).map { it.groupValues[1] }.toList()
            val titles = titleRegex.findAll(data).map { it.groupValues[1] }.toList()
            // 遍历数组
            for ((index,value) in titles.withIndex()){
                println("正在下载:$value")
                // 写入标题
                file.append("\n\n$value\n\n")
                // 写入章节
                file.append(getContent("http://www.qiushuge.net"+hrefs[index]))
                file.flush()
            }
            file.close()
        }
    })
}