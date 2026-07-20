# 官方轻量Python基础镜像
FROM python:3.11-slim

# 设置容器工作目录
WORKDIR /app

# 拷贝本地Python脚本进容器
COPY app.py /app/

# 暴露要求的8888端口
EXPOSE 8888

# 容器启动命令，运行web服务
CMD ["python3", "app.py"]
