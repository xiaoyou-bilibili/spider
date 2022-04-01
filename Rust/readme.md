## rust版本

### 环境搭建
rust官网：https://www.rust-lang.org/

大部分情况下。我们已经安装了rust，如果没有安装的话需要自己手动安装

```bash
# 安装rust
sudo apt update
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
# 查看rust的版本
rustup --version
```

### 扩展安装
```bash
# 安装网络请求库
sudo apt-get install libwww-rust
```

### 编译运行
```bash
# 编译程序
rustc spider.rs
# 运行程序
./spider
```