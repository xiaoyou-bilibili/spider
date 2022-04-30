## Go版本

### 环境搭建
go的安装参考：https://go.dev/doc/install
```bash
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
# 查看go版本
go version
```
### 初始化一个go项目（不需要执行这个命令）
```bash
go mod init spider
```

### 安装GBK编码插件
```bash
go get golang.org/x/text
```

### 安装colly框架
这个是第二种爬虫方法，第一种是使用正则
```bash
go get -u github.com/gocolly/colly
```

### 编译运行
> 注意，go项目里面只能有一个main函数，所以`main.go` 和 `colly.go`只能保留一个

```bash
# 使用正则
go run main.go
# 使用colly
go run colly.go
```