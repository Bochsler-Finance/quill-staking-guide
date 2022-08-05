#!/bin/bash

pandoc --css=styling.css -s -f markdown+smart --toc --metadata \
pagetitle="Quill Simple Guide" --to=html5 quill-guide.md \
-o quill-guide.html && \
xdg-open quill-guide.html
