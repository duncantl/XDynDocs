<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2003/XInclude"
	exclude-result-prefixes="c" version='1.0'
	xmlns:cpp="http://www.C++.org"
	xmlns:cpre="http://www.preprocessor.org"	
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

<xsl:template match="c:func|c:routine|cpp:routine">\Croutine{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:keyword | c:op | cpp:keyword">\Ckeyword{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:struct|c:type">\Ctype{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:arg|c:param">\Carg{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:var|cpp:var">\Cvar{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="c:field|c:el">\Cfield{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="c:expr|cpp:expr">\Cexpr{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="c:null">\Cnull</xsl:template>
<xsl:template match="c:double">\Cdouble{}</xsl:template>
<xsl:template match="c:int">\Cint</xsl:template>
<xsl:template match="c:float">\Cfloat</xsl:template>

<xsl:template match="cpp:class | c:class">\CppClass{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="cpp:this">\CppThis</xsl:template>

<xsl:template match="cpre:define">\CPreKeyword{\#define}</xsl:template>
<xsl:template match="cpre:var">\CPreVar{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="cpre:macro">\CPreMacro{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="clang">\Clang</xsl:template>

<xsl:template match="cpp:method">\CppMethod{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="c:header">\CHeaderFile{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="cpp:code">
<xsl:if test="$use.code.marginnote.identifiers">\begin{CRoutinePar}
</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">CppCode</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">
\end{CRoutinePar}</xsl:if>
</xsl:template>


<xsl:template match="gdb">GDB</xsl:template>
<xsl:template match="lldb">LLDB</xsl:template>

<xsl:template match="c:lib">\Clib{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>
