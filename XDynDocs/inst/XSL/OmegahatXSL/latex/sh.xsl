<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sh="http://www.shell.org"
        version="1.0">

<xsl:template match="sh:code | programlisting[@contentType = 'shell']">
<xsl:if test="$use.code.marginnote.identifiers">\begin{ShCodePar}</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">ShCode</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">\end{ShCodePar}</xsl:if>
</xsl:template>
<!-- <xsl:template match="sh:code | programlisting[@contentType = 'shell']">\begin{ShCode}<xsl:apply-templates/>\end{ShCode}</xsl:template> -->

<xsl:template match="sh:output">\begin{ShOutput}<xsl:apply-templates/>\end{ShOutput}</xsl:template>

<xsl:template match="sh:var">\ShellVar{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sh:cmd">\ShellCmd{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sh:exec">\textsl{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sh:glob">\textbf{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sh:expr">\texttt{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sh:op">\textbf{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>
