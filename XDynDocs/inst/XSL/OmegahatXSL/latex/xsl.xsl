<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:xi="http://www.w3.org/2003/XInclude"
                exclude-result-prefixes="xi xsl"
                version='1.0'>

<xsl:template match="xsl:code">\begin{verbatim}
<xsl:apply-templates/>
\end{verbatim}
</xsl:template>

<xsl:template match="xsl:template">\XSLtemplate{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>