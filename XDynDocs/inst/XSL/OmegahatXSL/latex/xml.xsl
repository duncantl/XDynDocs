<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xml="http://www.w3.org/XML/1998/namespace"
                xmlns:ltx="http://www.latex.org"
		xmlns:kml="http://earth.google.com/kml/2.1"
                version="1.0">

<!-- \verb+&lt;+\textit{}\verb+&gt;+ -->
<xsl:template match="xml:tag|xml:node|xml:element">\XMLTag{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="xml:tag[./ancestor::title]|xml:node[./ancestor::title]|xml:element[./ancestor::title]">\XMLTagTitle{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="xml:attr">\XMLAttr{<xsl:apply-templates/>}</xsl:template>

  <!--  Want to capitalize the First letter. -->
<xsl:template match="xml:*">\XML<xsl:value-of select="local-name()"/>{<xsl:apply-templates/>}</xsl:template>

<xsl:template name="makeCodeEnv">
  <xsl:param name="codeName"/>\begin{<xsl:value-of select="$codeName"/>}
<xsl:call-template name="trim-newlines"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template>
\end{<xsl:value-of select="$codeName"/>}<xsl:if test="not(local-name(following-sibling::* | following-sibling::text()[1]) = '') or 
 not(starts-with(following-sibling::*[1], '&#10;'))">::  <xsl:value-of select="not(local-name(following-sibling::*[1]) = '')"/><xsl:message>Adding space after <xsl:value-of select="$codeName"/> for <xsl:value-of select="local-name(following-sibling::*[1] | following-sibling::text()[1])"/></xsl:message><xsl:text>&#10;</xsl:text></xsl:if></xsl:template>
<!--  -->



<xsl:template match="programlisting[@contentType = 'XML' or @contentType = 'xml'] | xml:code">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">XMLCode</xsl:with-param></xsl:call-template>
</xsl:template>



<xsl:template match="programlisting[@contentType='SVG' or @contentType='svg']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">SVGCode</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="programlisting[@contentType='KML' or @contentType='kml']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">KMLCode</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template match="xml:code//text()"><xsl:value-of select="."/></xsl:template>

<xsl:template match="kml:style">\verb+<xsl:apply-templates/>+</xsl:template>
<xsl:template match="kml:style">\verb+<xsl:copy-of select="text()"/>+</xsl:template>


<xsl:template match="quote[@ltx:verb = 'true' ]">\verb+<xsl:apply-templates/>+</xsl:template>

<xsl:template match="xsl:param">\XSLparam{<xsl:value-of select="."/>}</xsl:template>


</xsl:stylesheet>


