#!/usr/bin/env python3
"""
syntaxguru   comprehensive syntax auditor for wooden ghost workspace
scans python and xml files detects syntax or parse errors and fixes them
"""

import ast
import sys
from pathlib import Path
import xml.etree.ElementTree as ET
import logging

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger('syntaxguru')

workspace = Path('.')

py_errors = []
xml_errors = []
xml_fixed = []

def scan_and_fix_xml(file_path: Path):
    try:
        # First try to parse as is
        ET.parse(file_path)
    except ET.ParseError as e:
        xml_errors.append((file_path, str(e)))
        try:
            # Attempt to fix by stripping leading/trailing whitespace
            content = file_path.read_text(encoding='utf-8', errors='ignore')
            content = content.strip()
            # Try parsing again
            ET.fromstring(content)
            # If successful, write the cleaned content back
            file_path.write_text(content, encoding='utf-8')
            xml_fixed.append(file_path)
        except Exception as fix_e:
            # If fixing fails, log the failure
            logger.error(f"Failed to fix {file_path}: {fix_e}")
    except Exception as e:
        xml_errors.append((file_path, str(e)))

def scan_python(file_path: Path):
    try:
        source = file_path.read_text(encoding='utf-8', errors='ignore')
        ast.parse(source, filename=str(file_path))
    except SyntaxError as e:
        py_errors.append((file_path, f"line {e.lineno}: {e.msg}"))
    except Exception as e:
        py_errors.append((file_path, str(e)))

def main():
    for path in workspace.rglob('*'):
        if not path.is_file():
            continue
        suffix = path.suffix.lower()
        if suffix == '.py':
            scan_python(path)
        elif suffix == '.xml':
            scan_and_fix_xml(path)

    logger.info('python files checked')
    logger.info(f'python syntax issues found {len(py_errors)}')
    for fp, err in py_errors:
        logger.info(f'{fp}:{err}')

    logger.info('xml files checked')
    logger.info(f'xml parse issues found {len(xml_errors)}')
    for fp, err in xml_errors:
        logger.info(f'{fp}:{err}')
        
    logger.info('xml files fixed')
    logger.info(f'xml files successfully fixed {len(xml_fixed)}')
    for fp in xml_fixed:
        logger.info(f'fixed {fp}')

    if py_errors or (xml_errors and not all(f in xml_fixed for f, _ in xml_errors)):
        sys.exit(1)
    else:
        logger.info('syntax audit complete. issues fixed or not detected.')

if __name__ == '__main__':
    main()
