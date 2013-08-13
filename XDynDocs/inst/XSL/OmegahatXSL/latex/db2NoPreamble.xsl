<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="doc" version='1.0'
        xmlns:c="http://www.C.org">

<xsl:include href="http://www.omegahat.org/XSL/latex/basicLatex.xsl"/>
<xsl:include href="http://www.omegahat.org/XSL/latex/c.xsl"/>

<xsl:template match="/">
<xsl:apply-templates select="/*/section"/>
</xsl:template>

<xsl:template match="llvm">\llvm</xsl:template>

<xsl:template match="q"/>

</xsl:stylesheet>
