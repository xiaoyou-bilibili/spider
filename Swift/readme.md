## Swift版本

### 环境搭建
下载地址：https://www.swift.org/download/#releases
```bash
# 安装必要依赖
sudo apt-get install \
          binutils \
          git \
          gnupg2 \
          libc6-dev \
          libcurl4 \
          libedit2 \
          libgcc-9-dev \
          libpython2.7 \
          libsqlite3-0 \
          libstdc++-9-dev \
          libxml2 \
          libz3-dev \
          pkg-config \
          tzdata \
          uuid-dev \
          zlib1g-dev
# 下载安装包
wget https://download.swift.org/swift-5.6.1-release/ubuntu1804/swift-5.6.1-RELEASE/swift-5.6.1-RELEASE-ubuntu18.04.tar.gz

# 解压并配置一下环境变量
tar xzf swift-5.6.1-RELEASE-ubuntu18.04.tar.gz
sudo mv swift-5.6.1-RELEASE-ubuntu18.04 /usr/share/swift
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

# 查看Swift版本
swift --version
```

### 初始化swift项目（不需要执行）
```bash
swift package init --type executable
```

### 依赖安装
所有的依赖都会放在`Package.swift`里面

### 运行代码
```bash
cd spider
# 运行单个文件
swift xxx.swift
# 构建项目
swift build
# 运行项目
swift run spider
```
> swift因为编码找不到很好的解决方案，这里处于未完成的状态