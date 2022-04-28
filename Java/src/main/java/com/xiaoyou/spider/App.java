package com.xiaoyou.spider;
// 使用xpath库
import org.seimicrawler.xpath.JXDocument;
import org.seimicrawler.xpath.JXNode;

import java.io.File;
import java.io.FileWriter;
import java.util.List;

// 主函数入口
public class App 
{
    // 下载章节内容
    public static String GetContent(String url){
        StringBuilder result= new StringBuilder();
        JXDocument doc = JXDocument.createByUrl(url);
        // 获取小说内容
        List<JXNode> content=doc.selN("//div[@id='content']/text()");
        for(JXNode node:content){
            result.append(node.toString()).append("\n");
        }
        return result.toString();
    }

    // 获取所有章节
    public static void GetAllCapter(){
        // 抓取html信息并转换为JXDocument对象
        JXDocument doc = JXDocument.createByUrl("http://www.qiushuge.net/zhongjidouluo/");
        // 获取所有的章节节点
        List<JXNode> names=doc.selN("//div[@class='listmain']/dl/dd/a");
        System.out.println("节点内容" + names.size());
        try{
            // 打开文件
            File file=new File("content.txt");
            if(!file.exists()){
                file.createNewFile();
            }
            // 初始化一个文件写入
            FileWriter fw=new FileWriter(file.getName(),true);
            for(int i=0;i<names.size();i++){
                // 获取标签地址
                String href = names.get(i).asElement().attr("href");
                // 获取标签的内容
                String text = names.get(i).asElement().ownText();
                System.out.println("正在下载 "+text);
                // 写入标题
                fw.write("\n\n"+text+"\n\n");
                // 写入内容
                fw.write(GetContent("http://www.qiushuge.net"+href));
            }
            fw.close();
        }catch (Exception e){
            System.out.println(e.toString());
        }
    }

    // 主函数入口
    public static void main( String[] args )
    {
        GetAllCapter();
    }
}
