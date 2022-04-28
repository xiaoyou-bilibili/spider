## Scala 版本

### 环境搭建
下载地址：https://www.swift.org/download/#releases
```bash
# 我们可以安装一下Scala的构建工具 https://get-coursier.io/docs/cli-installation
curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > cs
chmod +x cs
./cs setup
# 更新一下环境变量
source ~/.profile
# 然后我们查看一下Scala的版本
scala
```

### 创建项目（不需要执行）
```bash
# 我们创建一个scala3的项目
sbt new scala/scala3.g8
```

### 编译代码
```bash
# 我们可以先编译scala代码
scalac spider.scala
```