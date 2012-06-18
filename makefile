all: doc test

doc: doc/manual.six

doc/manual.six: makedoc.g maketest.g ListOfDocFiles.g \
		PackageInfo.g \
		doc/ToolsForHomalg.bib doc/*.xml doc/*.css \
		gap/*.gd gap/*.gi examples/*.g
	        gap makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gap maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/ToolsForHomalg.tar.gz --exclude ".DS_Store" --exclude "*~" ToolsForHomalg/doc/*.* ToolsForHomalg/doc/clean ToolsForHomalg/gap/*.{gi,gd} ToolsForHomalg/{CHANGES,PackageInfo.g,README,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g,ListOfDocFiles.g} ToolsForHomalg/examples/*.g)

WEBPOS=public_html
WEBPOS_FINAL=~/Sites/homalg-project/ToolsForHomalg

towww: archive
	echo '<?xml version="1.0" encoding="UTF-8"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.ToolsForHomalg
	cp doc/manual.pdf ${WEBPOS}/ToolsForHomalg.pdf
	cp doc/*.{css,html} ${WEBPOS}
	rm -f ${WEBPOS}/*.tar.gz
	mv ../tar/ToolsForHomalg.tar.gz ${WEBPOS}/ToolsForHomalg-`cat VERSION`.tar.gz
	rm -f ${WEBPOS_FINAL}/*.tar.gz
	cp ${WEBPOS}/* ${WEBPOS_FINAL}
	ln -s ToolsForHomalg-`cat VERSION`.tar.gz ${WEBPOS_FINAL}/ToolsForHomalg.tar.gz
