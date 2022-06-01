#!/bin/bash

PRACTICAL=${1}
DATE=$(date +'%Y-%m-%d')
pandoc ${PRACTICAL}/${PRACTICAL}.md \
	-o ${PRACTICAL}/${PRACTICAL}.pdf \
	--from markdown \
	--template eisvogel \
	--highlight-style tango \
	--variable date=${DATE} \
	--variable footer-left="Autumn Term 2022"
