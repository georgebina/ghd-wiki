<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs ditaarch"
  version="3.0">
  
  <xsl:param name="oxygen-web-author" select="'https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html'"/>
  <xsl:param name="ghuser" select="'georgebina'"/>
  <xsl:param name="ghproject" select="'ghd-wiki'"/>
  <xsl:param name="ghbranch" select="'master'"/>
  
  <xsl:param name="mdtopics" select="''"/>  
  <xsl:variable name="base" select="resolve-uri(document-uri(), '../wiki/')"/>
  
  <xsl:template name="main">
    <xsl:variable name="topics">
      <title>GitHub DITA Wiki!</title>
      <xsl:for-each select="collection('../wiki?select=*.dita')">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:result-document href="map.ditamap" doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd">
      <map>
        <xsl:copy-of select="$topics"/>
        <xsl:for-each select="tokenize($mdtopics, ',')">
          <topicref href="{encode-for-uri(.)}" format="markdown"/>
        </xsl:for-each>        
      </map>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:variable name="relativeLocation" select="substring-after(document-uri(.), 'wiki/')"/>
    <topicref href="{$relativeLocation}">
      <xsl:if test="*/prolog/metadata/data[@name='wh-tile']">
        <topicmeta>
          <xsl:apply-templates select="*/prolog/metadata/data[@name='wh-tile']" mode="copyMetadata"/>
        </topicmeta>
      </xsl:if>
    </topicref>
  </xsl:template>
  
  <xsl:template match="node() | @*" mode="copyMetadata">
    <xsl:copy copy-namespaces="false">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="data[@name='image']" mode="copyMetadata">
    <xsl:copy copy-namespaces="false">
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:attribute name="href" select="concat('wiki/', @href)"/>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>