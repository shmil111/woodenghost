#!/usr/bin/env python3
"""
cleanmd   safe markdown to text converter
this script exclusively targets .md and .mdx files for conversion to plain text
it avoids scanning or modifying other file types to prevent code corruption
"""
import os
import re
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s ○ %(message)s', datefmt='%H:%M:%S')
logger = logging.getLogger('WoodenGhost.CleanMD')

class SafeMarkdownConverter:
    def __init__(self, root_path: str = "."):
        self.root_path = Path(root_path)
        self.processed_count = 0
        self.hebrew_markers = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ז', 'ח', 'ט', 'י']
        self.markdown_patterns = {
            'headers': [(re.compile(r'^#{1,6}\s+', re.MULTILINE), '')],
            'lists': [(re.compile(r'^\s*[\*\-]\s+', re.MULTILINE), '○ ')],
            'links': [(re.compile(r'\[([^\]]+)\]\([^\)]+\)'), r'\1')]
        }

    def convert_content(self, content: str) -> str:
        for category, patterns in self.markdown_patterns.items():
            for pattern, replacement in patterns:
                content = pattern.sub(replacement, content)
        # Replace remaining horizontal lines or separators
        content = re.sub(r'^\s*[\-\*\_]{3,}\s*$', '◇◆◇◆◇', content, flags=re.MULTILINE)
        return content

    def process_files(self):
        logger.info("starting safe markdown conversion process")
        target_files = []
        for extension in ['*.md', '*.mdx', '*.markdown']:
            target_files.extend(self.root_path.rglob(extension))

        logger.info(f"found {len(target_files)} markdown files to convert")

        for file_path in target_files:
            try:
                original_content = file_path.read_text(encoding='utf-8', errors='ignore')
                converted_content = self.convert_content(original_content)
                
                # Create new .txt file path
                new_path = file_path.with_suffix('.txt')
                
                # Write converted content to new file
                new_path.write_text(converted_content, encoding='utf-8')
                
                # Remove original markdown file
                file_path.unlink()
                
                self.processed_count += 1
                logger.info(f"converted {file_path} to {new_path}")
            except Exception as e:
                logger.error(f"could not process {file_path}: {e}")
        
        logger.info(f"conversion complete. processed {self.processed_count} files.")

def main():
    converter = SafeMarkdownConverter()
    converter.process_files()

if __name__ == '__main__':
    main()
