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

### 创建cargo项目(不需要执行)
```bash
cargo new spider --bin
```

### 依赖安装(不需要执行)
默认情况下，依赖会自己自动安装，不需要同步依赖
https://docs.rs/reqwest/latest/reqwest/
```bash
# 依赖都在cargo.toml这个文件中，网络请求库主要是依赖下面这两个
reqwest = { version = "0.10", features = ["json"] }
tokio = { version = "0.2", features = ["full"] }
```

### 编译单个文件
```bash
# 编译程序
rustc spider.rs
# 运行程序
./spider
```

### 编译cargo项目
```bash
# 编译项目
cargo build
# 编译好后会在target/debug目录下有一个二进制文件
./target/debug/spider
# 也可以直接运行
cargo run
```

### 参考文档
http://llever.com/cargo-book-zh/getting-started/first-steps.zh.html
https://blog.csdn.net/shebao3333/article/details/106780900
https://llever.com/rust-cookbook-zh/text/regex.zh.html
https://docs.rs/regex/latest/regex/