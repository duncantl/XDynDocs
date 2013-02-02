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

<!-- <xsl:message>Adding space after <xsl:value-of select="$codeName"/> for <xsl:value-of select="local-name(following-sibling::*[1] | following-sibling::text()[1])"/></xsl:message> -->
<xsl:template name="makeCodeEnv">
  <xsl:param name="codeName">Verbatim</xsl:param>\begin{<xsl:value-of select="$codeName"/>}
<xsl:call-template name="trim-newlines"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template>
\end{<xsl:value-of select="$codeName"/>}<xsl:call-template name="forceBreakIf"/></xsl:template>

<!-- Add a new line to the output if there is a following sibling
  and it is either a node or text that doesn't start with white space. -->
<xsl:template name="forceBreakIf">
<xsl:variable name="next" select="(following-sibling::* | following-sibling::text())[1]"/>
<xsl:variable name="add" select="count($next) > 0 and (not(local-name($next) = '') or not(starts-with( translate(string($next), ' &#x09;', ''), '&#10;')))"/> 
<!--
<xsl:message>[forceBreakIf] (<xsl:value-of select="count($next)"/>)  <xsl:if test="not(@contentType)">(<xsl:value-of select="name()"/>)</xsl:if> <xsl:value-of select="@contentType"/>, add =  <xsl:value-of select="$add"/>,  count_p = <xsl:value-of select="count($next) > 0"/>,  local-name = <xsl:value-of select="not(local-name($next) = '')"/>,  starts-with = <xsl:value-of select="not(starts-with(translate(string($next), ' &#x09;', ''), '&#10;'))"/>,  <xsl:value-of select="not(local-name($next) = '') or starts-with(translate(string($next), ' &#x09;', ''), '&#10;')"/>, both = <xsl:value-of select="(not(local-name($next) = '') or not(starts-with(translate(string($next), ' &#x09;', ''), '&#10;')))"/>
<xsl:if test="@contentType = 'text'">'<xsl:value-of select="$next"/>'  First='<xsl:value-of select="substring(translate(string($next), ' ', ''), 1, 3)"/>'
</xsl:if>
</xsl:message> -->
<xsl:if test="$add"><xsl:text>XXX&#10;</xsl:text></xsl:if>
</xsl:template>

<!--  ::  <xsl:value-of select="not(local-name(following-sibling::*[1]) = '')"/> -->



<xsl:template match="programlisting[@contentType = 'XML' or @contentType = 'xml'] | xml:code">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">XMLCode</xsl:with-param></xsl:call-template>
</xsl:template>



<xsl:template match="programlisting[@contentType='SVG' or @contentType='svg']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">SVGCode</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="programlisting[@contentType='HTML' or @contentType='html']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">HTMLCode</xsl:with-param></xsl:call-template>
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


