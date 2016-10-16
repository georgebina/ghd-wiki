<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">
  
  <xsl:param name="oxygen-web-author" select="'https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html'"/>
  <xsl:param name="ghuser" select="'georgebina'"/>
  <xsl:param name="ghproject" select="'ghd-wiki'"/>
  <xsl:param name="ghbranch" select="'master'"/>
  
  <xsl:variable name="base" select="resolve-uri(document-uri(), '../wiki/')"/>
  
  <xsl:template name="main">
    <xsl:for-each select="collection('../wiki?select=*.dita')">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:variable name="relativeLocation" select="substring-after(document-uri(.), 'wiki/')"/>
    <xsl:result-document href="out/{replace($relativeLocation, '.dita$', '.html')}" method="xhtml">
      <xsl:apply-templates select="." mode="publish">
        <xsl:with-param name="editURL" 
          select="concat(
            $oxygen-web-author, 
            '?url=github%3A%2F%2FgetFileContent%2F', 
            $ghuser, '%2F', $ghproject, '%2F', $ghbranch, 
            '%2F', $relativeLocation)" tunnel="yes"/>
        <xsl:with-param name="historyURL" 
          select="concat(
            'https://github.com/', 
            $ghuser, '/', $ghproject, '/commits/', $ghbranch, 
            '/', $relativeLocation)" tunnel="yes"/>
        <xsl:with-param name="newFileURL" 
          select="concat(
            'https://github.com/', $ghuser, '/', $ghproject, '/new/', $ghbranch,'/wiki')" 
          tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="/" mode="publish">
    <xsl:param name="editURL" tunnel="yes"/>
    <xsl:param name="historyURL" tunnel="yes"/>
    <xsl:param name="newFileURL" tunnel="yes"/>
    <html>
      <head><title><xsl:value-of select="(.//title)[1]"/></title></head>
      <body>
        <div id="header">
          <a target="_blank" href="{$editURL}">Edit this page</a>
          <a target="_blank" href="{$historyURL}">Page history</a>
          <a target="_blank" href="{$newFileURL}">Create new file</a>
        </div>  
        <div id="content">
          <xsl:apply-templates mode="publish"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="title" mode="publish">
    <h1><xsl:apply-templates mode="publish"/></h1>
  </xsl:template>
  <xsl:template match="p" mode="publish">
    <p><xsl:apply-templates mode="publish"/></p>
  </xsl:template>
  
  <xsl:template match="ul" mode="publish">
    <ul><xsl:apply-templates mode="publish"/></ul>
  </xsl:template>
  <xsl:template match="ol" mode="publish">
    <ol><xsl:apply-templates mode="publish"/></ol>
  </xsl:template>
  <xsl:template match="li" mode="publish">
    <li><xsl:apply-templates mode="publish"/></li>
  </xsl:template>
  
  <xsl:template match="xref[@scope='external']" mode="publish">
    <a href="{@href}"><xsl:apply-templates mode="publish"/></a>
  </xsl:template>
  
  
  
  <xsl:template match="*" mode="publish">
    <div>
      <xsl:apply-templates mode="publish"/>
    </div>
  </xsl:template>
  
  
  
</xsl:stylesheet>