<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rx="http://www.regex.org"
        version="1.0">


<xsl:template match="rx:expr">\RegeEx{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="rx:code">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">RegexCode</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="rx:op">\RegeExOp{<xsl:apply-templates/>}</xsl:template>
</xsl:stylesheet>
