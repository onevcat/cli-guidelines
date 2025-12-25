#!/bin/bash
# Post-process HTML to remove newlines/spaces after Chinese punctuation
# Usage: Run after `hugo` build

find public -name "*.html" -exec perl -i -p0e 's/([，。、；：""''（）！？》])[\n ]+/\1/g' {} \;

echo "CJK spacing fixed in public/"
