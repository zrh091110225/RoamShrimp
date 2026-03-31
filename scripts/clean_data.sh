#!/usr/bin/env bash
# 清理 TabiClaw 数据脚本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DATA_DIR="$PROJECT_ROOT/data"
# shellcheck source=/dev/null
source "$PROJECT_ROOT/scripts/lib/config.sh"
load_runtime_config "$PROJECT_ROOT"

echo "=========================================="
echo "清理 TabiClaw 数据"
echo "=========================================="

# 1. 删除 images 和 journals 目录下的文件
echo "正在清理 images 目录..."
rm -rf "$DATA_DIR/images"/*

INDEX_FILE="$DATA_DIR/journals/index.md"
INDEX_INTRO="阿虾的环游中国旅行记录。"
if [[ -f "$INDEX_FILE" ]]; then
  EXISTING_INTRO=$(awk '
    BEGIN { capture=0 }
    /^# 每日游记索引$/ { capture=1; next }
    capture && /^## / { exit }
    capture {
      if (started == 0 && $0 == "") next
      started = 1
      print
    }
  ' "$INDEX_FILE")
  if [[ -n "${EXISTING_INTRO//$'\n'/}" ]]; then
    INDEX_INTRO="$EXISTING_INTRO"
  fi
fi

echo "正在清理 journals 目录..."
rm -rf "$DATA_DIR/journals"/*

# 重新创建 index.md，保持状态区和表头
ensure_journal_index "$PROJECT_ROOT" "0" "未知" "10000" "⚪ 未开始" "$(date +%Y-%m-%d)" "$INDEX_INTRO"
echo "✅ images 和 journals 目录下的文件已删除，并重建了 journals/index.md"

# 2. 清空 route.md
echo "正在清空 route.md..."
> "$DATA_DIR/route.md"
echo "✅ route.md 已清空"

# 3. 重置 index.md 状态部分
echo "正在重置 index.md 状态部分..."
update_journal_index_status "$PROJECT_ROOT" "0" "未知" "10000" "⚪ 未开始" "$(date +%Y-%m-%d)"
echo "✅ index.md 状态部分已重置"

# 4. 重置 status.json
echo "正在重置 status.json..."
cat > "$DATA_DIR/status.json" << EOF
{
  "current_day": 0,
  "current_city": "未知",
  "current_wallet": 10000,
  "last_updated": "$(date +%Y-%m-%d)",
  "status": "ready"
}
EOF
echo "✅ status.json 已重置"

echo "=========================================="
echo "清理完成！"
echo "=========================================="
