#!/bin/bash

cp quill-guide.md tmp.md
echo "<style>" >> tmp.md && cat styling.css >> tmp.md && echo "</style>" >> tmp.md
pandoc -s -f markdown+smart --toc --metadata \
pagetitle="Quill Simple Guide" --to=html5 tmp.md \
-o quill-guide.html && \
xdg-open quill-guide.html
rm tmp.md
