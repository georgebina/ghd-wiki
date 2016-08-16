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
      <head><title><xsl:value-of select="(.//title)[1]"/></title></head>
      <body>
        <xsl:apply-templates mode="publish"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="title" mode="publish">
    <h1><xsl:apply-templates mode="publish"/></h1>
  </xsl:template>
  <xsl:template match="p" mode="publish">
    <p><xsl:apply-templates mode="publish"/></p>
  </xsl:template>
  
  <xsl:template match="*" mode="publish">
    <div>
      <xsl:apply-templates mode="publish"/>
    </div>
  </xsl:template>
  
  
  
</xsl:stylesheet>