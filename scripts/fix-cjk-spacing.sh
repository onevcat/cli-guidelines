#!/bin/bash
# Post-process HTML to remove spaces/newlines after Chinese punctuation
# Usage: Run after `hugo` build

find public -name "*.html" -exec perl -CSDA -i -p0e '
  use utf8;
  s/。\s+/。/g;
  s/(。(?:<\/(?:strong|b|em|i|span|a|code|kbd|sup|sub)>)+)\s+/$1/g;
  s/([，。、；：""''（）！？》])\n+/\1/g;
  s/([，。、；：""''（）！？》])((?:<\/(?:strong|b|em|i|span|a|code|kbd|sup|sub)>)+)\s+((?:<(?:strong|b|em|i|span|a|code|kbd|sup|sub)[^>]*>)*)([\x{4E00}-\x{9FFF}])/\1\2\3\4/g;
  s/([，。、；：""''（）！？》])\s+((?:<(?:strong|b|em|i|span|a|code|kbd|sup|sub)[^>]*>)*)([\x{4E00}-\x{9FFF}])/\1\2\3/g;
' {} \;

echo "CJK spacing fixed in public/"
