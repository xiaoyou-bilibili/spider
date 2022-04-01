## JavaScript版本

### 环境搭建
nodejs官网：https://nodejs.org/
```bash
# 安装nodejs和npm
sudo apt update
sudo apt install nodejs npm
# 查看nodejs和npm版本
node -v
npm -v
```

### 初始化nodejs项目（不需要执行下面的命令）
```bash
npm init
# 安装编码工具（不需要执行，只是演示一下npm安装依赖）
npm i iconv-lite
# 安装请求库
npm i axios
# 安装html解析器
npm install cheerio
```

### 安装项目依赖
```bash
npm install
```

### 编译运行
```bash
# 运行项目
node index.js
```