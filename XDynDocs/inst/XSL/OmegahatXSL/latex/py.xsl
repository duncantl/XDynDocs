<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="c" version='1.0'
        xmlns:python="http://www.python.org">

<xsl:param name="use.code.marginnote.identifiers" select="false"/>

<xsl:template match="py:code">
<xsl:if test="$use.code.marginnote.identifiers">\begin{PyCodePar}
</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">PyCode</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">
\end{PyCodePar}</xsl:if>
</xsl:template>

<xsl:template match="c:func|c:routine">\Pyfunc{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="py:keyword">\Pykeyword{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="py:struct|py:type">\Pytype{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="py:arg">\Pyarg{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="py:var">\Pyvar{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="py:expr">\Pyexpr{<xsl:apply-templates/>}</xsl:template>





</xsl:stylesheet>