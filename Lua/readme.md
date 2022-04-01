## lua版本

### 环境搭建
lua官网：https://www.lua.org/

```bash
# 安装lua
sudo apt install lua5.3
sudo apt install liblua5.3-dev
# 安装lua的包管理工具
sudo apt install luarocks
# 查看lua的版本
lua -v
```

### 扩展安装
```bash
# 安装一下socket包
sudo luarocks install luasocket
# 安装编码转换包
sudo luarocks install lua-iconv
```

### 编译运行
```bash
# 运行脚本
lua spider.lua
```