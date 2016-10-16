#!/bin/bash

echo "====================================="
echo "clean output folder"
echo "====================================="
rm -Rf out

if [ ! -d "dita-ot-2.3.3" ]; then
  echo "====================================="
  echo "download DITA-OT"
  echo "====================================="
  wget https://github.com/dita-ot/dita-ot/releases/download/2.3.3/dita-ot-2.3.3.zip --no-check-certificate
  
  echo "====================================="
  echo "extract DITA-OT"
  echo "====================================="
  unzip dita-ot-2.3.3.zip
  rm dita-ot-2.3.3.zip
  
  echo "====================================="
  echo "download DITA-OT LW-DITA plugin"
  echo "====================================="
  
  wget https://github.com/oasis-open/dita-lightweight/archive/master.zip --no-check-certificate
  
  echo "====================================="
  echo "extract DITA-OT LW-DITA to DITA-OT"
  echo "====================================="
  
  unzip master.zip -d dita-ot-2.3.3
  mv dita-ot-2.3.3/dita-lightweight-master/org.oasis.lwdita dita-ot-2.3.3/plugins/
  rm master.zip
    
  echo "====================================="
  echo "download WebHelp plugin"
  echo "====================================="
  
  wget http://mirror.oxygenxml.com/InstData/Editor/Webhelp/oxygen-webhelp.zip
  
  echo "====================================="
  echo "extract WebHelp to DITA-OT"
  echo "====================================="
  unzip oxygen-webhelp.zip 
  cp -R com.oxygenxml.* dita-ot-2.3.3/plugins/
  mv dita-ot-2.3.3/plugins/com.oxygenxml.webhelp/plugin_2.x.xml dita-ot-2.3.3/plugins/com.oxygenxml.webhelp/plugin.xml
  rm -Rf com.oxygenxml.*
  rm oxygen-webhelp.zip
  rm oxygen_custom.xsl
  rm oxygen_custom_html.xsl
  
  echo "====================================="
  echo "Add Edit Link to DITA-OT"
  echo "====================================="
  
  # Add the editlink plugin
  git clone https://github.com/georgebina/ditaot-editlink-plugin dita-ot-2.3.3/plugins/com.oxygenxml.editlink/
  
  
  echo "====================================="
  echo "download Markdown plugin"
  echo "====================================="
  
  wget https://github.com/jelovirt/dita-ot-markdown/releases/download/1.1.0/com.elovirta.dita.markdown_1.1.0.zip --no-check-certificate
  
  echo "====================================="
  echo "extract MarkDown plugin"
  echo "====================================="
  unzip com.elovirta.dita.markdown_1.1.0.zip -d dita-ot-2.3.3/plugins/com.elovirta.dita.markdown
  rm com.elovirta.dita.markdown_1.1.0.zip
  
  
  echo "====================================="
  echo "integrate plugins"
  echo "====================================="
  
  cd dita-ot-2.3.3/
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
  rm SaxonHE9-7-0-7J.zip
fi

MDTOPICS=`ls -1 wiki/*.md | sed -e 's/$/,/' | tr -d "\n" | sed -e 's/,$//'`

java -cp saxon9/saxon9he.jar:dita-ot-2.3.3/lib/xml-resolver-1.2.jar net.sf.saxon.Transform -xsl:publish/generateMap.xsl -it:main -catalog:dita-ot-2.3.3/catalog-dita.xml ghuser=georgebina ghproject=ghd-wiki ghbranch=master oxygen-web-author=https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html mdtopics="$MDTOPICS"

cp licensekey.txt dita-ot-2.3.3/plugins/com.oxygenxml.webhelp/licensekey.txt


REPONAME="ghd-wiki"
USERNAME="georgebina"

# Send some parameters to the "editlink" plugin as system properties
export ANT_OPTS="$ANT_OPTS -Dditamap.path=map.ditamap"
export ANT_OPTS="$ANT_OPTS -Dcwd=`pwd`"
export ANT_OPTS="$ANT_OPTS -Drepo.url=github://getFileContent/$USERNAME/$REPONAME/master/"
export ANT_OPTS="$ANT_OPTS -Dwebapp.url=https://www.oxygenxml.com/webapp-demo-aws/"

dita-ot-2.3.3/bin/dita -i map.ditamap -f webhelp-responsive -o out/wiki/dita

cat map.ditamap

echo "====================================="
echo "publish"
echo "====================================="
java -cp saxon9/saxon9he.jar:dita-ot-2.3.3/lib/xml-resolver-1.2.jar net.sf.saxon.Transform -xsl:publish/publish.xsl -it:main -catalog:dita-ot-2.3.3/catalog-dita.xml ghuser=georgebina ghproject=ghd-wiki ghbranch=master oxygen-web-author=https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html

echo "====================================="
echo "index.html"
echo "====================================="
cat out/wiki/index.html

open out/wiki/index.html
open out/wiki/dita/index.html



