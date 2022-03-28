## java版本

### 环境搭建
```bash
sudo apt install openjdk-8-jdk
# 查看java版本
java -version
# 安装maven
sudo apt install maven
# 查看maven版本
mvn -version
```

### 初始化maven项目（不需要执行这个命令）
```bash
mvn archetype:generate
```

### maven依赖同步
```bash
mvn dependency:sources
```

### 编译运行
```bash
# 运行项目
bash build.sh
```