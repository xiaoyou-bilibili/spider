## c#版本

### 环境搭建

参考文档：https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu

```bash
# 添加仓库列表
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
# 安装sdk
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0
# 安装运行时
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-6.0
# 最后验证一下是否安装成功
dotnet --version
dotnet --info
```

### 项目初始化（已经初始化了，不需要运行）
```bash
dotnet new console --output spider
```

### 安装扩展包（需要支持GBK编码，这个要在spider项目里执行）
```bash
dotnet add package System.Text.Encoding.CodePages --version 6.0.0
```

### 运行项目
```bash
dotnet run
```
更多命令参考：https://docs.microsoft.com/zh-cn/dotnet/core/tools/dotnet-build