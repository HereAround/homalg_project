GAPPATH=/usr/local/lib/gap4r4
#
# makefile for the Gauss package                             Max Neunhoeffer
#
#  This file is free software, see license information at the end.
#  
CC=cc

GAPINCL=-I$(GAPPATH)/src -I$(GAPPATH)/bin/x86_64-unknown-linux-gnu-gcc

.PHONY: bindir clean doc test

default: bindir bin/x86_64-unknown-linux-gnu-gcc/gauss.so

# this target creates a bin-directory
bindir:
	if test ! -d bin;  then mkdir bin;  fi
	if test ! -d bin/x86_64-unknown-linux-gnu-gcc;  then mkdir bin/x86_64-unknown-linux-gnu-gcc;  fi

bin/x86_64-unknown-linux-gnu-gcc/gauss.so: src/gauss.c
	cp $(GAPPATH)/bin/x86_64-unknown-linux-gnu-gcc/config.h bin/x86_64-unknown-linux-gnu-gcc
	$(GAPPATH)/bin/x86_64-unknown-linux-gnu-gcc/gac -p "-g" -P "-g" -d -o bin/x86_64-unknown-linux-gnu-gcc/gauss.so src/gauss.c

# make a statically linked GAP including the io module
static:
	(cd $(GAPPATH)/bin/x86_64-unknown-linux-gnu-gcc; \
	./gac -o gap-static -p "-DGAUSSSTATIC" -P "-static" \
	../../pkg/Gauss/src/gauss.c)

doc: doc/manual.six

doc/manual.six: doc/Gauss.xml doc/install.xml \
		doc/examples.xml doc/intro.xml VERSION
	        gapL makedoc.g

clean:
	(cd doc ; ./clean)

archive: doc
	(mkdir -p ../tar; cd ..; tar czvf tar/Gauss.tar.gz --exclude ".svn" --exclude test --exclude "public_html" Gauss)

WEBPOS=~/gap/pkg/Gauss/public_html

towww: archive
	echo '<?xml version="1.0" encoding="ISO-8859-1"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
#	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.Gauss
	cp doc/manual.pdf ${WEBPOS}/Gauss.pdf
	cp ../tar/Gauss.tar.gz ${WEBPOS}

##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; version 2 of the License.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
##
