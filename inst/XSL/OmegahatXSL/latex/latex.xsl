<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ltx="http://www.latex.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
		xmlns:r="http://www.r-project.org"
		xmlns:str="http://exslt.org/strings"
		xmlns:mml="http://www.w3.org/1998/Math/MathML"
		xmlns:github="https://github.com"
		xmlns:git="https://git-scm.com"
                extension-element-prefixes="r"
                exclude-result-prefixes="r s ltx str mml"
                version="1.0"
	xmlns:mk="http://www.make.org">


<xsl:include href="../common/RCommonDocbook.xsl"/>
<xsl:include href="../common/no-html.xsl"/>
<xsl:include href="../common/no-fo.xsl"/>
<xsl:include href="../common/utils.xsl"/>

<xsl:include href="utils.xsl"/>


<xsl:include href="css.xsl"/>
<xsl:include href="languages.xsl"/>

<!-- https://pygments.org/  -->
<xsl:param name="use.minted" select="1"/>


<xsl:template match="latex">\LaTeX</xsl:template>

<xsl:template match="s:expression|r:expression|r:expr">\R<xsl:value-of select="local-name(.)"/>{<!--<xsl:apply-templates/>--><xsl:call-template name="scape"><xsl:with-param name="string" select="text()"/></xsl:call-template>}</xsl:template>


<xsl:template match="s:expression|r:expression|r:expr"><xsl:call-template name="addErrorMargin"/>{\color{rcolor}\<xsl:call-template name="verbName"/>|<xsl:apply-templates/>|}</xsl:template>

<!-- <xsl:template match="r:expr[ancestor::footnote]">{\color{rcolor}\<xsl:call-template name="verbName"/>?<xsl:apply-templates/>}</xsl:template> -->

<!-- map new lines to spaces in r:expr.  Need to ensure this is used. Seems not to be. -->
<xsl:template match="r:errorMsg/text() | r:expr/text()"><xsl:message>expression text</xsl:message><xsl:value-of select="translate(string(.),'&#x0A;',' ')"/></xsl:template>

<xsl:template match="r:formula">{\color{rformula}\<xsl:call-template name="verbName"/>!<xsl:apply-templates/>!}</xsl:template>


<!-- <xsl:template match="text()"><xsl:value-of select="str:replace(str:replace(string(.), '_', '\_'), '&amp;', '\&amp;')"/>}</xsl:template>-->

<!-- Was <xsl:apply-templates/>  rather than value-of select=replace() -->
<!-- <xsl:call-template name="string-replace-uscore"/> -->
<xsl:template match="r:var|s:variable|r:func">\R<xsl:value-of select="local-name(.)"/>{<xsl:value-of select="str:replace(str:replace(str:replace(str:replace(string(.), '_', '\_'), '%', '\%'), '{', '\{'), '&amp;', '\&amp;')"/>}</xsl:template>


<xsl:template match="r:env">\Renv{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="r:globalenv">\Renv{globalenv}</xsl:template>


<xsl:template match="r:func[contains(., '&lt;-')]">\RreplaceFunc{<xsl:value-of select="translate(., '&lt;-', '')"/>}</xsl:template>

<xsl:template name="RfunctionMarkup">
 <xsl:choose>
   <xsl:when test="contains(., '&lt;-')">\RreplaceFunc</xsl:when>
   <xsl:otherwise>\Rfunc</xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="s:func|s:functionRef">\Sfunc{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="s:arg|r:arg" name="rarg">\Sarg{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:class">\Rclass{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="s:param|r:param">\Sparam{<xsl:apply-templates/>}</xsl:template>

<!-- Used to have &#10; in several places -->
<!-- Not called (at least for book.xml) -->
<xsl:template match="r:output">\begin{tcboppbox}
\begin{ROutput}<xsl:apply-templates/>\end{ROutput}
\end{tcboppbox}</xsl:template>

<!-- trim white space.  Change to trim not normalize. -->
<!-- 
<xsl:if test="@id"><xsl:message>Routput: <xsl:value-of select="."/> + <xsl:value-of select="following-sibling::* | following-sibling::text()"/></xsl:message></xsl:if><xsl:if test="following-sibling::text()"><xsl:text>&#10;</xsl:text></xsl:if>
 -->
<xsl:template match="r:output[not(*)]">\begin{tcboppbox}
\begin{ROutput}
<xsl:call-template name="trim-newlines"><xsl:with-param name="string" select="string(.)"/></xsl:call-template>
\end{ROutput}
\end{tcboppbox}</xsl:template>

<!-- Want to be able to determine if next element is text and does not start with punctuation. If so, add a {}. -->
<xsl:template match="r:dots|dots">\ldots<xsl:if test="not(@nospace)">{}</xsl:if></xsl:template>


<xsl:template match="s:null|r:null">\Snull{}<xsl:call-template name="addBraces"/></xsl:template>
<xsl:template match="s:NA|r:NA">\SNA{}<xsl:call-template name="addBraces"/></xsl:template>
<xsl:template match="s:false|r:false|r:FALSE">\SFALSE{}<xsl:call-template name="addBraces"/></xsl:template>
<xsl:template match="s:true|r:true|r:TRUE">\STRUE{}<xsl:call-template name="addBraces"/></xsl:template>

<!-- Check to see if we need to add {} after a macro.Really want to check if the next element is text().  -->
<xsl:template name="addBraces"><xsl:if test="starts-with(string(following-sibling::text()[1]), ' ')"></xsl:if></xsl:template>

<!--  temporarily disable this Dec 21 2019
  <xsl:template match="r:code/r:output"><xsl:apply-templates/></xsl:template>
-->

<xsl:template match="r:output//text() | r:code//text()"><xsl:value-of select="."/></xsl:template>
<!-- <xsl:template match="r:output//text() | r:code//text()"><xsl:call-template name="trim.text"/></xsl:template> -->


<xsl:template name="addErrorMargin"><xsl:if test="@error = 'true'">\marginnote{\includegraphics{MarginImages/no-symbol-hi_48.png}}</xsl:if></xsl:template>

<xsl:template match="r:function|r:code|s:code|s:plot|r:plot|r:test"><xsl:call-template name="addErrorMargin"/>\begin{CodeChunk}
\begin{R<xsl:value-of select="local-name()"/>}<xsl:apply-templates/>\end{R<xsl:value-of select="local-name()"/>}
\end{CodeChunk}</xsl:template>


<xsl:template match="current-date">
 <xsl:value-of select="r:call('date')"/>
</xsl:template>

<!--<xsl:text>&#010;</xsl:text>-->
<xsl:template match="ltx:*|tex|ltx|latex[string(.) != '']|ltx:literal">
 <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="ltx:eqn"><xsl:apply-templates/></xsl:template>

<xsl:template match="mml:eqn"><xsl:message>ignoring MathML</xsl:message></xsl:template>


<xsl:template match="acronymDef"><xsl:apply-templates/></xsl:template>

<xsl:template match="var">\var{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="mk:code">\begin<xsl:choose><xsl:when test="$use.minted">{minted}{Makefile}</xsl:when><xsl:otherwise>{verbatim}</xsl:otherwise></xsl:choose><xsl:apply-templates/>\end{<xsl:choose><xsl:when test="$use.minted">minted</xsl:when><xsl:otherwise>verbatim</xsl:otherwise></xsl:choose>}</xsl:template>


<xsl:template match="emdash|dash">---</xsl:template>
<xsl:template match="emdash[./* or ./text()]|dash[./* or ./text()]">--- <xsl:apply-templates/> ---</xsl:template>
<xsl:template match="ndash">--</xsl:template>


<xsl:template match="makeGlossary">
<xsl:if test="not(ancestor::glossary)">
\section{Glossary}\label{sec:glossary}
</xsl:if>
\begin{tabularx}{lp{4in}}
Acronym &amp; Definition \\
<xsl:apply-templates select="//acronymDef | //acronym[@def]" mode="glossary"/>
\end{tabularx}
</xsl:template>

<xsl:template match="acronymDef" mode="glossary">
<xsl:value-of select="@value"/>  &amp;  <xsl:apply-templates/> \\
</xsl:template>

<xsl:template match="acronym[@def]" mode="glossary">
<xsl:apply-templates /> &amp; <xsl:value-of select="@def"/> \\
</xsl:template>

<xsl:template match="acronym">\acronym{<xsl:apply-templates />}</xsl:template>
<xsl:template match="acronym[markupLang]"><xsl:apply-templates /></xsl:template>
<xsl:template match="acronym[@index = 'true']">\acronym{<xsl:apply-templates />}\index{<xsl:value-of select="."/>}</xsl:template>
<!-- <xsl:template match="acronym[. = 'XML']">XML</xsl:template> -->

<xsl:template match="r:help">?\texttt{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="author">
\author{<xsl:apply-templates/>}
</xsl:template>



<xsl:template match="r:op">\Rop{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="r:op[string(.)='$']">\Rop{\$}</xsl:template>
<xsl:template match="r:op[string(.)='~']">\Rop{\texttildelow}</xsl:template>
<xsl:template match="r:keyword">\Rkeyword{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="r:if">\Rkeyword{if}</xsl:template>
<xsl:template match="r:else">\Rkeyword{else}</xsl:template>
<xsl:template match="r:for">\Rkeyword{for}</xsl:template>
<xsl:template match="r:in">\Rkeyword{in}</xsl:template>

<xsl:template match="r:numeric|r:vector|r:list|r:character|r:logical|r:integer|r:raw|r:factor">\Rtype{<xsl:value-of select="local-name()"/>}</xsl:template>

<xsl:template match="r:type">\Rtype{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="r:nla|r:ggets">\Rnla</xsl:template>


<xsl:template match="index[not(primary)]">
<xsl:apply-templates/>\index{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="index[not(primary) and @term]" priority="100">
<xsl:value-of select="."/>\index{<xsl:value-of select="@term"/>}</xsl:template>

<xsl:template match="index[@visible='false']" priority="100">
\index{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="title//index"><xsl:apply-templates/></xsl:template>

<xsl:template match="index[@key]" priority="100">
<xsl:apply-templates/>\index{<xsl:value-of select="@key"/>@<xsl:choose><xsl:when test="@term"><xsl:value-of select="@term"/></xsl:when><xsl:otherwise><xsl:value-of select="."/></xsl:otherwise></xsl:choose>}</xsl:template>


<xsl:template match="r:arg[@func]">
<xsl:call-template name="rarg"/>\sindex[Rfunc]{<xsl:value-of select="@func"/>@\Rfunc{<xsl:value-of select="@func"/>}!<xsl:value-of select="string(.)"/>@<xsl:call-template name="rarg"/><xsl:text>}</xsl:text>
</xsl:template>


<xsl:template match="squote">`<xsl:apply-templates/>'</xsl:template>
<xsl:template match="quote|dquote|dQuote">``<xsl:apply-templates/>''</xsl:template>

<xsl:template match="i">\textit{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="github:repos">\textsl{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="github:hash">\texttt{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="git">\textsl{git}\index{G@git}</xsl:template>
<xsl:template match="git:*">\textbf{<xsl:value-of select='local-name()'/>}\index{<xsl:value-of select='local-name()'/>}</xsl:template>


<xsl:template match="msword|word">\textsl{Microsoft Word}\index{Word}</xsl:template>
<xsl:template match="msexcel|excel">\textsl{Microsoft Excel}\index{Excel}</xsl:template>
<xsl:template match="mspowerpoint|powerpoint|msppt">\textsl{Microsoft PowerPoint}\index{PowerPoint}</xsl:template>
<xsl:template match="keynote">\textsl{Keynote}\index{Keynote}</xsl:template>

<xsl:template match="firefox">\textsl{Firefox}\index{Firefox}</xsl:template>

<xsl:template match="apache">\textsl{Apache}\index{Apache}</xsl:template>

<xsl:template match="rstudio">\textsl{RStudio}\index{RStudio}</xsl:template>


<xsl:template match="quotation">
\begin{displayquote}
<xsl:apply-templates/>
\end{displayquote}  
</xsl:template>

<xsl:template match="hr">
\noindent\rule{\textwidth}{1pt}
</xsl:template>


<xsl:template match="red">{\color{RED}<xsl:apply-templates/>}</xsl:template>


</xsl:stylesheet>

