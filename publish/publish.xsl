<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">
  
  <xsl:template name="main">
    <xsl:for-each select="collection('../wiki?select=*.dita')">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:variable name="relativeLocation" select="substring-after(document-uri(.), 'wiki/')"/>
    <xsl:result-document href="out/{replace($relativeLocation, '.dita$', '.html')}" method="xhtml">
      <xsl:apply-templates select="." mode="publish"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="/" mode="publish">
    <html>
      <head><title></title></head>
      <body>
        <xsl:apply-templates mode="publish"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="node() | @*" mode="publish">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="publish"/>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:stylesheet>