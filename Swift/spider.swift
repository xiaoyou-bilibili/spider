import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


// 发送网络请求
func get(url_str:String) -> String{
    // 构建URL
    let url:URL = URL(string: url_str)!
    // 发送HTTP请求的的session对象
    let session = URLSession.shared
    // 构建请求request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    // 发一个get请求
    let task = session.dataTask(with: request as URLRequest) {(
        data, response, error) in
        
        guard let data = data, let _:URLResponse = response, error == nil else {
            print("error")
            return
        }
        let dataString =  String(data: data, encoding: String.Encoding.utf8)
        let dict = self.getDictionaryFromJSONString(jsonString: dataString!)
        print(dict)
    }
    task.resume()


    return url
}




print(get(url_str:"http://www.qiushuge.net/zhongjidouluo/"))