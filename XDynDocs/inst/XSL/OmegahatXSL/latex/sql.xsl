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
<xsl:template match="sql:op">\SQLOp{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sql:table">\SQLTable{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sql:fun|sql:func">\SQLFun{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sql:clause|sql:expr">\SQLExpr{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="sql:opt|sql:keyword">\SQLKeyword{<xsl:apply-templates/>}</xsl:template>

<!-- proglisting. See r:code. Is there a general way we do this -->
<xsl:template match="sql:code">\begin{CodeChunk}
\begin{SQLcode}<xsl:apply-templates/>\end{SQLcode}
\end{CodeChunk}</xsl:template>
</xsl:stylesheet>