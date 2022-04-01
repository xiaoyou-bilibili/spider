## kotlin版本

### 环境搭建
kotlin官网：https://kotlinlang.org/
grade安装参考：https://gradle.org/install/#manually

```bash
# 安装kotlin
sudo snap install --classic kotlin
# 查看kotlin版本
kotlin -version
# 下面安装一下gradle(注意自己到官网下载最新版)
wget https://downloads.gradle-dn.com/distributions/gradle-7.4.1-all.zip
# 创建一个文件来存放gradle
sudo mkdir /opt/gradle
# 解压
sudo unzip -d /opt/gradle gradle-7.4.1-all.zip
# 可以查看一下当前目录下的文件
ls /opt/gradle/gradle-7.4.1
# 最后设置一下环境变量
export PATH=$PATH:/opt/gradle/gradle-7.4.1/bin
# 查看版本
gradle -v
```

### 项目新建(仅供参考，不需要输入)
```bash
# 新建一个kotlin项目
gradle init --type=kotlin-application
```


### 运行单个kotlin文件(不需要输入)
```bash
# 编译我们的kotlin代码，然后输出为jar文件
# include-runtime表示让 .jar 文件包含 Kotlin 运行库，从而可以直接运行。
kotlinc spider.kt -include-runtime -d spider.jar
# 运行我们的jar文件
java -jar spider.jar
```

### 项目依赖

网络请求使用的是okhttp：https://github.com/square/okhttp

### 刷新依赖

所有的依赖都放在`app/build.gradle.kts` 里面。
更多的命令参考：https://docs.gradle.org/current/userguide/dependency_management.html#dependency_management_in_gradle

```bash
gradle build --refresh-dependencies
```



### 编译运行
```bash
# 启动项目
./gradlew run
```