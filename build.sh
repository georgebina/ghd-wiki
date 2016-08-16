#!/bin/bash

echo "====================================="
echo "clean output folder"
echo "====================================="
rm -Rf out

echo "====================================="
echo "download DITA-OT"
echo "====================================="
wget https://github.com/dita-ot/dita-ot/releases/download/2.2.3/dita-ot-2.2.3.zip --no-check-certificate

echo "====================================="
echo "extract DITA-OT"
echo "====================================="
unzip dita-ot-2.2.3.zip

echo "====================================="
echo "download Saxon9"
echo "====================================="
wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/SaxonHE9-7-0-7J.zip --no-check-certificate

echo "====================================="
echo "extract Saxon9"
echo "====================================="
unzip SaxonHE9-7-0-7J.zip -d saxon9/

echo "====================================="
echo "publish"
echo "====================================="
java -cp saxon9/saxon9he.jar:dita-ot-2.2.3/lib/xml-resolver-1.2.jar net.sf.saxon.Transform -xsl:publish/publish.xsl -it:main -catalog:dita-ot-2.2.3/catalog-dita.xml 

echo "====================================="
echo "remove downloaded DITA-OT"
echo "====================================="
rm -Rf dita-ot-2.2.3
rm dita-ot-2.2.3.zip

echo "====================================="
echo "remove downloaded Saxon9"
echo "====================================="
rm -Rf saxon9
rm SaxonHE9-7-0-7J.zip


echo "====================================="
echo "index.html"
echo "====================================="
cat out/wiki/index.html