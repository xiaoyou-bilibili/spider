# 设置项目名称
project(spider)
# 设置cmake标准
set(CMAKE_CXX_STANDARD 14)
# 设置c++标准
set(CMAKE_CXX_FLAGS"${CMAKE_CXX_FLAGS} -std=c++11 -lcurl")
# 设置原文件
set(SOURCE_FILES main.cpp)
# 指定我们的可执行文件
add_executable(spider ${SOURCE_FILES})
# 链接对象库,这里加上curl请求库
target_link_libraries(spider curl)


