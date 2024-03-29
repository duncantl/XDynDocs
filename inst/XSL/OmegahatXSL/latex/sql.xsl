<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://www.sql.org"
        version="1.0">

<!-- 
sql:func
sql:var

sql:code 

sql:arg 
sql:clause 
sql:fun 
sql:table 
sql:op 
sql:opt 
 -->

<xsl:template match="sql:var">\SQLVar{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sql:arg">\SQLArg{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sql:op">\SQLOp{<xsl:apply-templates/>}\index{<xsl:apply-templates/>@\SQLOp{<xsl:apply-templates/>}}</xsl:template>
<xsl:template match="sql:column">\SQLColumn{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sql:table">\SQLTable{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sql:fun|sql:func">\SQLFun{<xsl:apply-templates/>}\index{<xsl:apply-templates/>@\SQLFun{<xsl:apply-templates/>}}</xsl:template>
<xsl:template match="sql:cmd">\SQLCmd{<xsl:apply-templates/>}\index{<xsl:apply-templates/>@\SQLFun{<xsl:apply-templates/>}}</xsl:template>

<xsl:template match="sql:clause|sql:expr">\SQLExpr{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sql:opt|sql:keyword|sql:kw">\SQLKeyword{<xsl:apply-templates/>}\index{<xsl:apply-templates/>@\SQLKeyword{<xsl:apply-templates/>}}</xsl:template>

<!-- proglisting. See r:code. Is there a general way we do this -->
<xsl:template match="sql:code">\begin{CodeChunk}
\begin{SQLcode}<xsl:apply-templates/>\end{SQLcode}
\end{CodeChunk}</xsl:template>


<xsl:template match="sql:code">
<xsl:if test="$use.code.marginnote.identifiers">\begin{SQLCodePar}[<xsl:value-of select="(string-length() - string-length(translate(., '&#xA;', '')) - 1) div 2"/>]
<!-- <xsl:message>[sql:code] Num lines: <xsl:value-of select="string-length() - string-length(translate(., '&#xA;', '')) - 1"/></xsl:message>-->
</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">SQLCode</xsl:with-param><xsl:with-param name="lang">sql</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">
\end{SQLCodePar}</xsl:if>
</xsl:template>

<xsl:template match="sql:exec">\SQLExec{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sqlite|sqlite3">SQLite3</xsl:template>


<xsl:template match="sql:output">\begin{SqlOutput}<xsl:if test="@size">[fontsize=\<xsl:value-of select="@size"/>]</xsl:if><xsl:apply-templates/>\end{SqlOutput}</xsl:template>

</xsl:stylesheet>
