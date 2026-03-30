#!/usr/bin/env python3
"""
图片压缩工具 - 使用 TinyPNG API
用法: python3 scripts/compress_image.py <图片路径> [TinyPNG_API_KEY]
"""

import sys
import os
import tinify
import tempfile

def compress_image(image_path, api_key=None):
    """压缩图片"""
    if not api_key:
        # 从环境变量或配置文件读取
        api_key = os.environ.get('TINYPNG_API_KEY')
    
    if not api_key:
        print("Error: TinyPNG API key not provided")
        print("Usage: python3 compress_image.py <image> [API_KEY]")
        print("Or set TINYPNG_API_KEY environment variable")
        sys.exit(1)
    
    try:
        tinify.key = api_key
        
        # 压缩
        source = tinify.from_file(image_path)
        source.to_file(image_path)
        
        # 获取压缩后大小
        new_size = os.path.getsize(image_path)
        print(f"Compressed: {image_path}")
        print(f"New size: {new_size / 1024:.1f} KB")
        return True
        
    except tinify.Error as e:
        print(f"TinyPNG Error: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 compress_image.py <image> [API_KEY]")
        sys.exit(1)
    
    image_path = sys.argv[1]
    api_key = sys.argv[2] if len(sys.argv) > 2 else None
    
    compress_image(image_path, api_key)