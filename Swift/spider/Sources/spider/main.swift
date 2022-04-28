import Alamofire

// 发送网络请求
func get(url_str:String) async -> String{
    let request = AF.request(url_str)
    // Later...
    let stringResponse = await request.serializingString().response
    print(stringResponse)
    return url_str
}

// 主函数中调用异步的方法
let task = Task{
    await get(url_str:"http://www.qiushuge.net/zhongjidouluo/")
    task.cancel()
}


// 等待程序执行完成。。目前没啥好方法，只能使用这种比较笨的方式
while !task.isCancelled {}

