#include <fstream>
#include <iostream>
#include <regex>
#include <curl/curl.h>
// 编码转换
#include <iconv.h>
using  namespace  std;

// 接收数据
size_t receive_data(void *contents, size_t size, size_t nmemb, void *stream){
    string *str = (string*)stream;
    (*str).append((char*)contents, size*nmemb);
    return size * nmemb;
}

// GBK转换为utf-8编码（如果是UTF-8编码就不需要转换）
int GbkToUtf8(char *str_str, size_t src_len, char *dst_str, size_t dst_len)
{
	iconv_t cd;
	char **pin = &str_str;
	char **pout = &dst_str;

	cd = iconv_open("utf8", "gbk");
	if (cd == 0)
		return -1;
	memset(dst_str, 0, dst_len);
	if (iconv(cd, pin, &src_len, pout, &dst_len) == -1)
		return -1;
	iconv_close(cd);
	**pout = '\0';

	return 0;
}

// 发送http请求
CURLcode HttpGet(const std::string & strUrl, std::string & strResponse,int nTimeout){
    // 初始化curl对象
    CURLcode res;
    CURL* pCURL = curl_easy_init();

    if (pCURL == NULL) {
        return CURLE_FAILED_INIT;
    }

    // 设置curl的属性
    curl_easy_setopt(pCURL, CURLOPT_URL, strUrl.c_str());
    //curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
    // 下面两个都是设置超时的
    curl_easy_setopt(pCURL, CURLOPT_NOSIGNAL, 1L);
    curl_easy_setopt(pCURL, CURLOPT_TIMEOUT, nTimeout);
    // 设置数据传输进度相关的参数，这里指定一个接收的函数
    curl_easy_setopt(pCURL, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(pCURL, CURLOPT_WRITEFUNCTION, receive_data);
    // 返回结果
    curl_easy_setopt(pCURL, CURLOPT_WRITEDATA, (void*)&strResponse);
    // 开始请求
    res = curl_easy_perform(pCURL);
    curl_easy_cleanup(pCURL);
    return res;
}

// 发送get请求
string Get(const string& url){
    string strResponse;
    CURLcode nRes =HttpGet(url, strResponse,300);
    // 因为爬取到的内容编码是GBK，需要转换为utf-8
    char dst_utf8[1024000] = {0};
	GbkToUtf8((char*)strResponse.c_str(), strlen(strResponse.c_str()), dst_utf8, sizeof(dst_utf8));
	// 直接把char[] 转换为string
    string response = dst_utf8;
    return response;
}

// 正则匹配获取匹配到的对象
std::vector<string> FindAllMatch(string data,const string& re){
    regex reg(re);
    smatch result;
    string::const_iterator iterStart = data.begin();
    string::const_iterator iterEnd = data.end();
    string temp;
    std::vector<string> response;
    // 查找匹配的字符串
    while (regex_search(iterStart, iterEnd, result, reg))
    {
        // 把查找查找到的字符放入容器中
        response.push_back(result[1]);
        iterStart = result[0].second;	//更新搜索起始位置,搜索剩下的字符串
    }
    return response;
}

// c++字符串替换
std::string subreplace(std::string resource_str, std::string sub_str, std::string new_str)
{
    std::string dst_str = resource_str;
    std::string::size_type pos = 0;
    while((pos = dst_str.find(sub_str)) != std::string::npos)   //替换所有指定子串
    {
        dst_str.replace(pos, sub_str.length(), new_str);
    }
    return dst_str;
}

// 获取章节内容
string GetContent(const string& url){
    string data=Get(url);
    auto contents = FindAllMatch(data,"showtxt\">([\\s\\S]*?)</div>");
    string response;
    if(contents.size()>0){
        // 替换掉不需要的内容
        auto tmp = subreplace(contents[0],"&nbsp;","");
        response = subreplace(tmp,"<br />","\n");
    }
    // 返回最后结果
    return response;
}

// 获取所有章节
void GetAllCapter(){
    string data=Get("http://www.qiushuge.net/zhongjidouluo/");
    // 查找所有的链接和章节名称
    auto links = FindAllMatch(data,"<dd><a href =\"(.*?)\"");
    auto names = FindAllMatch(data,"\">(.*?)</a></dd>");
    cout<<"输出结果"<<links.size()<<" |"<<names.size();
    // 开始写入文件
    ofstream out("content.txt");
    // 遍历所有的链接
    for(int i=0;i<links.size();i++){
        if(i < links.size() && i<names.size()){
            // 写入文章内容
            out<< names[i]+"\n\n";
            cout<<"正在下载"<<":"<<names[i]<<endl;
            // 把章节内容也写进去
            out<< GetContent("http://www.qiushuge.net" + links[i]);
        }
    }
    // 关闭文件
    out.close();
}


int main()
{
   GetAllCapter();
    return 0;
}