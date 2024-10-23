#!/bin/bash

# 脚本署名信息
echo "Shaipot 安装和挖矿脚本"
echo "作者推特: https://x.com/BtcK241918"
echo

# 检查并安装 Git
if ! command -v git &> /dev/null; then
    echo "Git 未安装，正在安装..."
    sudo apt update
    sudo apt install -y git
fi

# 检查 OpenSSL 是否已安装
if ! dpkg -l | grep -q libssl-dev; then
    echo "正在安装 libssl-dev..."
    sudo apt update
    sudo apt install -y libssl-dev
fi

# 检查 Rust 和 Cargo 是否已安装
if ! command -v cargo &> /dev/null; then
    echo "Rust 和 Cargo 未安装，请先安装 Rust。"
    exit 1
fi

# 克隆 Shaipot 仓库
if [ ! -d "shaipot" ]; then
    echo "克隆 Shaipot 仓库..."
    git clone https://github.com/shaicoin/shaipot.git
fi

# 导航到 shaipot 目录
cd shaipot || exit

# 编译项目
echo "正在编译 Shaipot..."
cargo rustc --release -- -C opt-level=3 -C target-cpu=native -C codegen-units=1 -C debuginfo=0

# 检查编译是否成功
if [ ! -f "target/release/shaipot" ]; then
    echo "编译失败，请检查错误信息。"
    exit 1
fi

# 提示用户输入地址和线程数
read -p "请输入你的 Shaicoin 地址: " ADDRESS
read -p "请输入要使用的线程数: " THREADS

# 运行挖矿程序
echo "正在运行 Shaipot 挖矿程序..."
./target/release/shaipot --address "$ADDRESS" --pool wss://pool.shaicoin.org --threads "$THREADS" --vdftime 1.5
