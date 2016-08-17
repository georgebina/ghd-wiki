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
echo "download DITA-OT LW-DITA plugin"
echo "====================================="

wget https://github.com/oasis-open/dita-lightweight/archive/master.zip --no-check-certificate

echo "====================================="
echo "extract DITA-OT LW-DITA to DITA-OT"
echo "====================================="

unzip master.zip -d dita-ot-2.2.3
mv dita-ot-2.2.3/dita-lightweight-master/org.oasis.lwdita dita-ot-2.2.3/plugins/

echo "====================================="
echo "integrate plugins"
echo "====================================="

cd dita-ot-2.2.3/
bin/ant -f integrator.xml 
cd ..

echo "====================================="
echo "download Saxon9"
echo "====================================="
wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/SaxonHE9-7-0-7J.zip --no-check-certificate

echo "====================================="
echo "extract Saxon9"
echo "====================================="
unzip SaxonHE9-7-0-7J.zip -d saxon9/

REPONAME=`basename $PWD`
PARENTDIR=`dirname $PWD`
USERNAME=`basename $PARENTDIR`

# https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html
# <xsl:param name="oxygen-web-author" select="'https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html'"/>
# $USERNAME
# <xsl:param name="ghuser" select="'georgebina'"/>
# $REPONAME
# <xsl:param name="ghproject" select="'ghd-wiki'"/>
# $TRAVIS_BRANCH
# <xsl:param name="ghbranch" select="'master'"/>


echo "====================================="
echo "publish"
echo "====================================="
java -cp saxon9/saxon9he.jar:dita-ot-2.2.3/lib/xml-resolver-1.2.jar net.sf.saxon.Transform -xsl:publish/publish.xsl -it:main -catalog:dita-ot-2.2.3/catalog-dita.xml ghuser=$USERNAME ghproject=$REPONAME ghbranch=$TRAVIS_BRANCH oxygen-web-author=https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html

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