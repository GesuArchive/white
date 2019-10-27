#!/bin/bash
FROM=WINDOWS-1251
TO=UTF-8
ICONV="iconv -f $FROM -t $TO"
# Convert
find . -type f -name "*.json" | while read fn; do
cp ${fn} ${fn}.bak
$ICONV < ${fn}.bak > ${fn}
rm ${fn}.bak
done