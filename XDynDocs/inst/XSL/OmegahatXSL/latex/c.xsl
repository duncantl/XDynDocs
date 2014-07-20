<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="c" version='1.0'
	xmlns:cpp="http://www.C++.org"
        xmlns:c="http://www.C.org">

<xsl:param name="use.code.marginnote.identifiers" select="false"/>

<xsl:template match="c:code">
<xsl:if test="$use.code.marginnote.identifiers">\begin{CRoutinePar}
</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">CCode</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">
\end{CRoutinePar}</xsl:if>
</xsl:template>

<xsl:template match="c:function">
<xsl:if test="$use.code.marginnote.identifiers">\begin{CRoutinePar}
</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">CRoutine</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">
\end{CRoutinePar}</xsl:if>
</xsl:template>

<xsl:template match="c:func|c:routine">\Croutine{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:keyword">\Ckeyword{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:struct|c:type">\Ctype{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:arg">\Carg{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:var">\Cvar{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="c:expr">\Cexpr{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:null">\Cnull</xsl:template>
<xsl:template match="c:double">\Cdouble</xsl:template>
<xsl:template match="c:int">\Cint</xsl:template>

<xsl:template match="cpp:class">\CppClass{<xsl:apply-templates/>}</xsl:template>





</xsl:stylesheet>