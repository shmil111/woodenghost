#!/usr/bin/env python3
"""
repairxml   xml file repair utility for wooden ghost
scans for malformed xml files and attempts to fix them by removing leading invalid characters
"""

import os
from pathlib import Path
import logging
import xml.etree.ElementTree as ET

logging.basicConfig(level=logging.INFO, format='%(asctime)s ○ %(message)s', datefmt='%H:%M:%S')
logger = logging.getLogger('WoodenGhost.RepairXML')

class XMLRepairer:
    def __init__(self, root_path: str = "."):
        self.root_path = Path(root_path)
        self.repaired_count = 0
        self.error_count = 0

    def repair_xml_file(self, file_path: Path):
        try:
            # Try to parse the file as is first
            ET.parse(file_path)
        except ET.ParseError:
            try:
                # If parsing fails, read the content and attempt to fix it
                content = file_path.read_text(encoding='utf-8', errors='ignore')
                
                # Find the first '<' which should be the start of the XML content
                first_bracket = content.find('<')
                
                if first_bracket != -1:
                    # Strip everything before the first '<'
                    cleaned_content = content[first_bracket:]
                    
                    # Try to parse the cleaned content to see if it's valid now
                    ET.fromstring(cleaned_content)
                    
                    # If parsing the cleaned content succeeds, write it back to the file
                    file_path.write_text(cleaned_content, encoding='utf-8')
                    self.repaired_count += 1
                    logger.info(f"repaired {file_path}")
                else:
                    self.error_count += 1
                    logger.warning(f"could not find start of xml content in {file_path}")

            except Exception as e:
                self.error_count += 1
                logger.error(f"failed to repair {file_path}: {e}")

    def scan_and_repair(self):
        logger.info("starting xml repair process")
        xml_files = list(self.root_path.rglob('*.xml'))
        logger.info(f"found {len(xml_files)} xml files to check")

        for file_path in xml_files:
            self.repair_xml_file(file_path)
            
        logger.info(f"repair process complete. repaired {self.repaired_count} files.")
        if self.error_count > 0:
            logger.warning(f"failed to repair {self.error_count} files.")

def main():
    repairer = XMLRepairer()
    repairer.scan_and_repair()

if __name__ == '__main__':
    main()
