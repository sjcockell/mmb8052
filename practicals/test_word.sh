#!/bin/bash

PRACTICAL=${1}
DATE=$(date +'%Y-%m-%d')
pandoc ${PRACTICAL}/${PRACTICAL}.md \
	-o ${PRACTICAL}/${PRACTICAL}.docx \
	--from markdown \
	--highlight-style tango \
	--variable date=${DATE} \
	--reference-doc=template/reference.docx

