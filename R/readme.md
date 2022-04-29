## R 版本

### 环境搭建
下载地址：https://cran.r-project.org/
```bash
# 安装必要依赖
sudo apt install --no-install-recommends software-properties-common dirmngr
# 添加仓库
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# 安装R语言
sudo apt install --no-install-recommends r-base
# 查看R语言版本
R --version
```

## 安装相关包
```bash
# 进入交互界面
R
# 安装http请求包
install.packages("httr")
# 安装字符串处理包
install.packages("stringr")
```

### 运行代码
```bash
# 运行代码
Rscript spider.R
```