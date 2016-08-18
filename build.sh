#!/bin/bash

echo "====================================="
echo "clean output folder"
echo "====================================="
rm -Rf out


if [ ! -d "dita-ot-2.2.3" ]; then
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
fi

if [ ! -d "saxon9" ]; then
  echo "====================================="
  echo "download Saxon9"
  echo "====================================="
  wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/SaxonHE9-7-0-7J.zip --no-check-certificate
  
  echo "====================================="
  echo "extract Saxon9"
  echo "====================================="
  unzip SaxonHE9-7-0-7J.zip -d saxon9/
fi

echo "====================================="
echo "publish"
echo "====================================="
java -cp saxon9/saxon9he.jar:dita-ot-2.2.3/lib/xml-resolver-1.2.jar net.sf.saxon.Transform -xsl:publish/publish.xsl -it:main -catalog:dita-ot-2.2.3/catalog-dita.xml ghuser=georgebina ghproject=ghd-wiki ghbranch=master oxygen-web-author=https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html




echo "====================================="
echo "index.html"
echo "====================================="
cat out/wiki/index.html
open out/wiki/index.html