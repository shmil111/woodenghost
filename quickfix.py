#!/usr/bin/env python3

# Quick XML repair
content = open('repositories/GhidraMCP/pom.xml').read()

# Fix all remaining issues in one pass
import re

# Fix missing angle brackets and proper indentation
content = re.sub(r'systemPath([^<]+)/systemPath', r'            <systemPath>\1</systemPath>', content)
content = re.sub(r'</dependency>\s*<dependency><groupId>', r'        </dependency>\n        <dependency>\n            <groupId>', content)
content = re.sub(r'<groupId>([^<]+)</groupId>\s*<artifactId>([^<]+)</artifactId>\s*version([^/]+)/version\s*scopesystem/scope', 
                 r'            <groupId>\1</groupId>\n            <artifactId>\2</artifactId>\n            <version>\3</version>\n            <scope>system</scope>', content)

# Fix any remaining broken tags
content = re.sub(r'([a-zA-Z]+)([^<>]*)/([a-zA-Z]+)', r'<\1>\2</\3>', content)

# Write the fixed file
with open('repositories/GhidraMCP/pom.xml', 'w') as f:
    f.write(content)

print("✓ Fixed XML formatting")