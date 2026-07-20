# 基于官方Nginx基础镜像
FROM nginx:latest

# 将本地自定义网页复制到Nginx站点根目录，覆盖默认页面
COPY index.html /usr/share/nginx/html/index.html

# 对外暴露80网页端口
EXPOSE 80

# Nginx前台启动命令（容器标准启动指令）
CMD ["nginx", "-g", "daemon off;"]
