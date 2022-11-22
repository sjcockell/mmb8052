#!/bin/bash

PRACTICAL=${1}
DATE=$(date +'%Y-%m-%d')
pandoc ${PRACTICAL}/${PRACTICAL}.md \
	-o ${PRACTICAL}/${PRACTICAL}.html \
	--from markdown \
	--highlight-style tango \
	--variable date=${DATE} \
