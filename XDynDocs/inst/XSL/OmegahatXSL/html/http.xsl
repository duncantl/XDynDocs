<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	 xmlns:http="http://www.w3.org/Protocols"
       version="1.0">

<xsl:template match="http:post">
<code class="httpOp">POST</code>
</xsl:template>
<xsl:template match="http:get">
<code class="httpOp">GET</code>
</xsl:template>
<xsl:template match="http:put">
<code class="httpOp">PUT</code>
</xsl:template>


<xsl:template match="http:headerFieldName">
<code color="httpHeaderField">'<xsl:apply-templates/>'</code>
</xsl:template>

</xsl:stylesheet>