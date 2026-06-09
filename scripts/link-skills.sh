#!/usr/bin/env bash
set -euo pipefail

# สคริปต์สำหรับเชื่อมโยง Jakkawan's AI Standards ไปยัง Global Claude CLI
# แก้ไข: ให้หา Root Directory โดยถอยหลังจากโฟลเดอร์ scripts ไป 1 ระดับ

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"

# ป้องกันการลิงก์ทับซ้อนตัวเองที่โฟลเดอร์หลัก
if [ -L "$DEST" ]; then
  resolved="$(readlink -f "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "Error: $DEST is already a symlink into this repo ($resolved)." >&2
      echo "Please remove it first: rm \"$DEST\"" >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$DEST"
echo "เริ่มทำการ Link Skills จาก $REPO/skills ไปยัง $DEST..."

# ค้นหาและลิงก์เฉพาะไฟล์ SKILL.md ที่พร้อมใช้งาน
find "$REPO/skills" -name SKILL.md \
  -not -path '*/node_modules/*' \
  -not -path '*/deprecated/*' \
  -not -path '*/in-progress/*' \
  -print0 |
while IFS= read -r -d '' skill_md; do
  src_dir="$(dirname "$skill_md")"
  name="$(basename "$src_dir")"
  target_dir="$DEST/$name"
  target_file="$target_dir/SKILL.md"

  # 1. เคลียร์ Symlink เก่าที่เป็น "แบบโฟลเดอร์" ทิ้งก่อน (ถ้ามี)
  if [ -L "$target_dir" ]; then
    rm "$target_dir"
  fi

  # 2. สร้างโฟลเดอร์จริงๆ (Physical Directory) ไว้ที่ปลายทาง
  mkdir -p "$target_dir"

  # 3. สร้าง Symlink เฉพาะไฟล์ SKILL.md ชี้กลับมาที่ Source
  ln -sfn "$skill_md" "$target_file"
  echo "Linked file: $name/SKILL.md -> $skill_md"
done

echo "สมบูรณ์! Claude CLI ของคุณได้รับการอัปเกรดเรียบร้อยแล้ว"
