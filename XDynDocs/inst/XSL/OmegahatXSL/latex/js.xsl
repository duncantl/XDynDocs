<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ltx="http://www.latex.org"
                xmlns:js="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
		xmlns:r="http://www.r-project.org"
		xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="r js"
                exclude-result-prefixes="r s ltx js str"
                version="1.0">

<xsl:template match="js:method|js:func|js:var|js:keyword|js:field|js:param">\JS<xsl:value-of select="local-name()"/>{<xsl:value-of select="str:replace(string(.), '_', '\_')"/>}</xsl:template>



<!-- FIXME.  Make this a LaTeX macro and have the color be set there. Have to avoid processing the text literally
   but treat it as verbatim. -->
<xsl:template match="js:value | js:expr">{\color{jscolor}\<xsl:call-template name="verbName"/>+<xsl:apply-templates/>+}</xsl:template>
<xsl:template match="js:expr[contains(string(.), '+')]">{\color{jscolor}\<xsl:call-template name="verbName"/>|<xsl:apply-templates/>|}</xsl:template>

<xsl:template match="js:null">\JSNull{}</xsl:template>

<!-- Make certain newlines don't mess up the verb+....+, so normalize-space for text() nodes within these -->
<xsl:template match="text()[ancestor::js:expr]">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="js:code//text()"><xsl:value-of select="."/></xsl:template>

<xsl:template match="js:code | programlisting[@contentType = 'JavaScript']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">JSCode</xsl:with-param></xsl:call-template>
</xsl:template>

</xsl:stylesheet>