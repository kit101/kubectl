#!/bin/bash

set -e

# 添加信号处理函数
handle_sigterm() {
  echo "Received SIGTERM or SIGINT, shutting down gracefully..."
  # 如果有filebrowser进程在运行，杀掉它
  if pgrep filebrowser > /dev/null; then
    echo "Stopping filebrowser..."
    pkill filebrowser
  fi
  exit 0
}

# 注册信号处理
trap handle_sigterm SIGTERM SIGINT

config_path="/etc/filebrowser/.filebrowser.json"
port=${FB_PORT:-8080}
branding_name="$(hostname)-filebrowser"
if [ ! -z "$FB_ADMIN_PASS" ]; then
  admin_password=${FB_ADMIN_PASS}
else
  admin_password=$(head -c 1024 /dev/urandom | tr -dc '0-9a-zA-Z' | head -c 20)
fi

# 打印帮助文档，例如环境变量如何使用、文档、默认配置文件如何变更等
echo "Usage: [filebrowser command]"
echo "Environment Variables:"
echo "  FB_ROOT: The root directory to serve (required for filebrowser mode)"
echo "  FB_ADMIN_PASS: The admin user password (optional, auto-generated if not set)"
echo "  FB_PORT: The port to listen on (default: 8080)"
echo "  FB_DISABLE_EXEC: Disable exec command (default: false, docs: https://filebrowser.org/configuration.html#command-execution)"
echo "Default Configuration File: $config_path"
echo "You can change the default configuration by modifying the file at $config_path"
echo " ---------------------------------------------------------------------------- "

if [ "$1" = '' ]; then
  if [ "$FB_ROOT" != '' ]; then
    filebrowser config import $config_path > /dev/null
    filebrowser config set --root $FB_ROOT --port $port --branding.name $branding_name > /dev/null
    filebrowser users add admin $admin_password --perm.admin > /dev/null
    if [ -z "$FB_ADMIN_PASS" ]; then
      echo "User 'admin' initialized with randomly generated password: $admin_password"
    fi
    exec filebrowser
  else
    echo "No FB_ROOT set, entering sleep mode."
    while true; do sleep 5; done
  fi
fi

exec "$@"

