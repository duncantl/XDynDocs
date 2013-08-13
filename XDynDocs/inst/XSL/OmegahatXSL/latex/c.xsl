<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="c" version='1.0'
        xmlns:c="http://www.C.org">


<xsl:template match="c:code">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">CCode</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="c:func|c:routine">\Cfunc{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="c:keyword">\Ckeyword{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="c:struct|c:type">\Ctype{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="c:arg">\Carg{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:var">\Cvar{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>