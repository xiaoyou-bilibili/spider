## PHP版本

### 环境搭建
PHP官网：https://www.php.net/
```bash
sudo apt install php
# 查看PHP版本
php --version
```
### 安装依赖
php解析DOM可以使用phpQuery，github地址:
https://github.com/punkave/phpQuery

```bash
#安装curl扩展，用于请求网页
sudo apt-get install php-curl
#安装dom扩展，用于解析dom
sudo apt-get install php-dom
```

### 编译运行
```bash
# 运行脚本
php spider.php
```