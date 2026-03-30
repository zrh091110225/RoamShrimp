#!/usr/bin/env bash
# RoamShrimp 初始化检查脚本
# 检查所有配置文件是否完整

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================="
echo "RoamShrimp 初始化检查"
echo "=========================================="

CONFIG_DIR="$PROJECT_ROOT/config"
DATA_DIR="$PROJECT_ROOT/data"

# 检查配置文件
echo ""
echo "检查配置文件..."

check_file() {
  local file="$1"
  local name="$2"
  if [[ -f "$file" ]]; then
    echo "  ✅ $name"
    return 0
  else
    echo "  ❌ $name (缺失)"
    return 1
  fi
}

MISSING=0
check_file "$CONFIG_DIR/persona.md" "人设配置 (persona.md)" || MISSING=1
check_file "$CONFIG_DIR/style.md" "文风配置 (style.md)" || MISSING=1
check_file "$CONFIG_DIR/image_style.md" "图片风格配置 (image_style.md)" || MISSING=1
check_file "$CONFIG_DIR/settings.yaml" "基本配置 (settings.yaml)" || MISSING=1

echo ""
echo "检查运行时数据..."

check_file "$DATA_DIR/route.md" "城市路径 (route.md)" || MISSING=1

# 检查工具脚本
echo ""
echo "检查工具脚本..."

TOOLS_PATH="/Users/hymanhai/.openclaw/workspace/tools"

check_file "$TOOLS_PATH/route.py" "路线查询工具 (route.py)" || MISSING=1
check_file "$TOOLS_PATH/attractions.py" "景点查询工具 (attractions.py)" || MISSING=1
check_file "$TOOLS_PATH/photo_spots.py" "打卡点查询工具 (photo_spots.py)" || MISSING=1
check_file "$TOOLS_PATH/weather.py" "天气查询工具 (weather.py)" || MISSING=1
check_file "$TOOLS_PATH/city_map.json" "城市映射 (city_map.json)" || MISSING=1

echo ""
if [[ $MISSING -eq 1 ]]; then
  echo "⚠️  有配置文件缺失，请补充后再运行"
  exit 1
else
  echo "✅ 所有配置文件完整!"
  
  # 显示当前状态
  echo ""
  echo "当前状态:"
  if [[ -f "$DATA_DIR/status.json" ]]; then
    cat "$DATA_DIR/status.json"
  else
    echo "  (首次运行，将从 settings.yaml 初始化)"
  fi
  
  echo ""
  echo "城市路径:"
  if [[ -f "$DATA_DIR/route.md" ]]; then
    cat "$DATA_DIR/route.md"
  fi
fi