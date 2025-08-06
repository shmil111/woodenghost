#!/usr/bin/env python3

import re

# Read the corrupted pom.xml
with open('repositories/GhidraMCP/pom.xml', 'r') as f:
    content = f.read()

# Apply comprehensive fixes
fixes = [
    (r'version([^<]+)/version', r'<version>\1</version>'),
    (r'scope([^<]+)/scope', r'<scope>\1</scope>'),
    (r'systemPath([^<]+)/systemPath', r'<systemPath>\1</systemPath>'),
    (r'/dependency', r'</dependency>'),
    (r'dependency\s*(?!>)', r'<dependency>'),
    (r'groupId([^<]+)/groupId', r'<groupId>\1</groupId>'),
    (r'artifactId([^<]+)/artifactId', r'<artifactId>\1</artifactId>'),
    (r'/dependencies', r'</dependencies>'),
    (r'/project', r'</project>'),
    (r'build', r'<build>'),
    (r'/build', r'</build>'),
    (r'plugins', r'<plugins>'),
    (r'/plugins', r'</plugins>'),
    (r'plugin\s*(?!>)', r'<plugin>'),
    (r'/plugin', r'</plugin>'),
    (r'configuration', r'<configuration>'),
    (r'/configuration', r'</configuration>'),
    (r'source([^<]+)/source', r'<source>\1</source>'),
    (r'target([^<]+)/target', r'<target>\1</target>'),
]

for pattern, replacement in fixes:
    content = re.sub(pattern, replacement, content)

# Write the fixed content
with open('repositories/GhidraMCP/pom.xml', 'w') as f:
    f.write(content)

print("Fixed pom.xml file")