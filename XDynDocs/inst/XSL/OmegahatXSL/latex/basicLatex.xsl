<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:s="http://cm.bell-labs.com/stat/S4"
        xmlns:r="http://www.r-project.org"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:svg="http://www.w3.org/2000/svg" 
	xmlns:js="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
        xmlns:str="http://exslt.org/strings"
	xmlns:ltx="http://www.latex.org"
	exclude-result-prefixes="doc str" version='1.0'
        xmlns:xp="http://www.w3.org/TR/xpath"
        xmlns:c="http://www.C.org"
        xmlns:make="http://www.make.org">

<xsl:import href="dblatex.xsl"/>

<xsl:import href="js.xsl"/>
<xsl:import href="xpath.xsl"/>


<xsl:include href="latex.xsl"/>
<xsl:include href="entities.xsl"/>

<xsl:include href="../common/fileRefs.xsl"/>
<xsl:include href="svg.xsl"/>
<xsl:include href="xml.xsl"/>

<xsl:include href="table.xsl"/>

<xsl:include href="sh.xsl"/>
<xsl:include href="xsl.xsl"/>

<xsl:include href="languages.xsl"/>


<xsl:output method="text" omit-xml-declaration="yes"/>

<xsl:param name="latex.macro.file">latexMacros</xsl:param>
<xsl:param name="load.cprotect" select="1"/>

<xsl:param name="programlisting.style"/>

<xsl:param name="default.cite.cmd">citep</xsl:param>

<!-- <xsl:strip-space elements="*"/>  -->
<xsl:preserve-space elements="*"/>
<xsl:strip-space elements="
abstract affiliation anchor answer appendix area areaset areaspec
artheader article audiodata audioobject author authorblurb authorgroup
beginpage bibliodiv biblioentry bibliography biblioset blockquote book
bookbiblio bookinfo callout calloutlist caption caution chapter
citerefentry cmdsynopsis co collab colophon colspec confgroup
copyright dedication docinfo editor entry entrytbl epigraph equation
example figure footnote footnoteref formalpara funcprototype
funcsynopsis glossary glossdef glossdiv glossentry glosslist graphicco
group highlights imagedata imageobject imageobjectco important index
indexdiv indexentry indexterm informalequation informalexample
informalfigure informaltable inlineequation inlinemediaobject
itemizedlist itermset keycombo keywordset legalnotice listitem lot
mediaobject mediaobjectco menuchoice msg msgentry msgexplan msginfo
msgmain msgrel msgset msgsub msgtext note objectinfo
orderedlist othercredit part partintro preface printhistory procedure
programlisting programlistingco publisher qandadiv qandaentry qandaset question
refentry reference refmeta refnamediv refsect1 refsect1info refsect2
refsect2info refsect3 refsect3info refsynopsisdiv refsynopsisdivinfo
revhistory revision row sbr screenco screenshot sect1 sect1info sect2
sect2info sect3 sect3info sect4 sect4info sect5 sect5info section
sectioninfo seglistitem segmentedlist seriesinfo set setindex setinfo
shortcut sidebar simplelist simplesect spanspec step subject
subjectset substeps synopfragment table tbody textobject tfoot tgroup
thead tip toc tocchap toclevel1 toclevel2 toclevel3 toclevel4
toclevel5 tocpart varargs variablelist varlistentry videodata
videoobject void warning subjectset

classsynopsis
constructorsynopsis
destructorsynopsis
fieldsynopsis
methodparam
methodsynopsis
ooclass
ooexception
oointerface
simplemsgentry
"/>

<!-- 
   <xsl:preserve-space elements="text()"/>
-->

<xsl:template match="comment()">%</xsl:template>
<xsl:template match="comment()"/>
<xsl:template match="comment()[following-sibling::figure]">%<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="caption//comment()">%</xsl:template>

<xsl:template match="extension">\textsl{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="protocol">\protocol{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="matlab">\proglang{MATLAB}</xsl:template>
<xsl:template match="python">\proglang{Python}</xsl:template>
<xsl:template match="fop">\ShApp{FOP}</xsl:template>


<!--  See if we can use the "scape" template and defaults in dblatex. -->
<xsl:template match="text()[not(ancestor::c:code) and not(ancestor::r:function) and not(ancestor::r:code) and not(ancestor::r:output) and not(ancestor::xml:code) and not(ancestor::js:code) and not(ancestor::svg:code) and not(ancestor::programlisting)]"><xsl:value-of select="str:replace(str:replace(str:replace(str:replace(str:replace(str:replace(str:replace(string(.), '&amp;', '\&amp;'), '_', '\_'), '#', '\#'), '%', '\%'), '{', '\lcurly'), '}', '\rcurly'), '$', '\$')"/></xsl:template>

<xsl:template match="text()[ancestor::programlisting or ancestor::xp:expr or ancestor::r:code or ancestor::r:output or ancestor::r:function or ancestor::xsl:code or ancestor::make:code or ancestor::literal]">
<xsl:copy select="."/>
</xsl:template>

<xsl:template name="replace-leading-newlines">
<xsl:param name="string"/>
<xsl:choose><xsl:when test="substring($string, 1, 1) = '&#10;'">
  <xsl:call-template name="replace-leading-newlines">
   <xsl:with-param name="string" select="substring($string, 2)"/>
  </xsl:call-template>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="trim-newlines">
<xsl:param name="string"/>
 <xsl:call-template name="replace-leading-newlines">
   <xsl:with-param name="string">
       <xsl:call-template name="replace-trailing-newlines"><xsl:with-param name="string" select="."/></xsl:call-template>
   </xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template name="replace-trailing-newlines">
<xsl:param name="string"/>
<xsl:choose><xsl:when test="substring($string, string-length($string)) = '&#10;'">
  <xsl:call-template name="replace-trailing-newlines">
   <xsl:with-param name="string" select="substring($string, 1, string-length($string)-1)"/>
  </xsl:call-template>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="xpara/text()"><xsl:value-of select="translate(string(.), '&#10;', ' ')"/></xsl:template>


<!-- Remove any new line at the end -->
<!--
<xsl:template match="para/text()[local-name(following-sibling::*[1]) = 'code' and
substring(., string-length(.) -1, string-length(.)) = '&#10;']"><xsl:message>trailing para/text() '<xsl:value-of select="translate(., '&#10;', 'X')"/>'</xsl:message><xsl:value-of select="substring(., 1, string-length(.)-2)"/></xsl:template>

<xsl:template match="para/text()[local-name(preceding-sibling::*[1]) = 'code' and substring(., 1, 1) = '&#10;']"><xsl:message>preceding para/text() '<xsl:value-of select="."/>'</xsl:message><xsl:call-template name="replace-leading-newlines"><xsl:with-param name="string" select="substring(., 2, string-length(.))"/></xsl:call-template></xsl:template>
-->


<!--
<xsl:template match="text()[normalize-space()]">
<xsl:value-of select="normalize-space()"/>
</xsl:template>

<xsl:template match="text()[not(normalize-space())]" />
-->
<xsl:param name="bibliog.file" />

<xsl:param name="doc.class">{article}</xsl:param>

<xsl:template match="/article">
\documentclass<xsl:value-of select="$doc.class"/>
\usepackage[authoryear,round]{natbib}
\usepackage{hyperref}
\usepackage{graphicx}
\usepackage{caption}
\usepackage{listings}
\usepackage{enumerate}

%\usepackage{times}
%\usepackage{fullpage}
\usepackage{supertabular}

<xsl:if test="(//caption//r:expr | //caption//r:formula) or $load.cprotect > 0">
\usepackage{cprotect}
</xsl:if>


% From http://stackoverflow.com/questions/741985/latex-source-code-listing-like-in-professional-books
%\usepackage{beramono}  % This messes up the regular verbatim mode.
\lstset {                 % A rudimentary config that shows off some features.
    basicstyle=\ttfamily, % Without beramono, we'd get cmtt, the teletype font.
    commentstyle=\textit, % cmtt doesn't do italics. It might do slanted text though.
    tabsize=4            % Or whatever you use in your editor, I suppose.
}

% These and \author and \PlainAuthor interact with each other.
%\usepackage{colortbl}
%\usepackage{dbk_table}

\usepackage{appendix}
\usepackage{fancyvrb}
\usepackage{float}
\usepackage{tabularx}

\def\hyperlabel#1{}

<xsl:if test="//example">
\newcounter{example}
\newenvironment{example}[1][]{\refstepcounter{example}\par\medskip\noindent%
   \textbf{Example~\theexample. #1} \rmfamily}{\medskip}
</xsl:if>

<xsl:apply-templates select="./articleinfo/authorgroup|./articleinfo/author"/>
<xsl:apply-templates select="./articleinfo//abstract|./abstract"/>
<xsl:apply-templates select="./articleinfo//title|./title"/>
<xsl:apply-templates select="./articleinfo//titleabbrev|./titleabbrev"/>
<xsl:apply-templates select="./articleinfo//keywordset | ./articleinfo//keywords"/>

\Address{
<xsl:apply-templates select="./articleinfo//author/address"/>
}

\input{<xsl:value-of select="$latex.macro.file"/>}

\begin{document}

<xsl:apply-templates select="./chapter | ./section | ./ackno | ./bibliography | ./appendix"/>

\end{document}
</xsl:template>


<xsl:template match="XXX_authorgroup">
\author{<xsl:for-each select="./author"><xsl:apply-templates select="."/>
<xsl:if test="not(position() = last())"><xsl:text> \And 
</xsl:text></xsl:if></xsl:for-each>}
</xsl:template>


<xsl:template match="keywordset|keywords">

</xsl:template>

<xsl:template match="keyword" mode="plain">
<xsl:message>plain keyword  <xsl:value-of select="string(.)"/></xsl:message>
<xsl:apply-templates select=".//text()"/>
</xsl:template>

<!-- Like to be able to do this more generically -->
<xsl:template match="js" mode="plain">JavaScript</xsl:template>


<xsl:template match="articleinfo/title">
\title{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="author/affiliation">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="author">
\author{
<xsl:apply-templates select="firstname"/><xsl:text> </xsl:text><xsl:apply-templates select="surname"/> \\
  <xsl:apply-templates select="affiliation"/>
}
</xsl:template>

<!-- 
<xsl:template match="figure">
\begin{figure}[H]
\begin{center}
<xsl:apply-templates/>
\end{center}
\label{<xsl:value-of select="@id"/>}
\end{figure}
</xsl:template>
 -->

<xsl:template match="r:makePlot">
\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="graphic/@fileref"/></xsl:with-param></xsl:call-template>}
</xsl:template>

<xsl:template match="r:makePlot[contains(graphic/@fileref, '.svg')]">
<xsl:apply-templates select="graphic"/>
</xsl:template>

<xsl:template match="figure/title[following-sibling::caption]"/>

<xsl:template match="figure/title[following-sibling::caption]" mode="title">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="caption">
<xsl:if test="//r:expr|//r:formula|xp:expr">\cprotect</xsl:if>\caption{<xsl:apply-templates/>}
<xsl:if test="ancestor::figure/@id">\label{<xsl:value-of select="ancestor::figure/@id"/>}</xsl:if>
</xsl:template>


<xsl:template match="figure[title]/caption">
<xsl:if test=".//r:expr|.//r:formula|xp:expr|.//literal|.//title|../title//r:expr|../title//r:formula|../title/xp:expr|../title//literal">\cprotect</xsl:if>\caption[<xsl:apply-templates select="../title" mode="title"/>]{<xsl:apply-templates select="../title" mode="title"/><xsl:if test="not(substring(normalize-space(title), string-length(normalize-space(title))) =  '.')">.  </xsl:if> <xsl:apply-templates/>}
<xsl:if test="ancestor::figure/@id">\label{<xsl:value-of select="ancestor::figure/@id"/>}</xsl:if>
</xsl:template>



<xsl:template match="dyngraphic"/>
<xsl:template match="comment"/>



<xsl:template match="r:slot">\Rslot{<xsl:apply-templates/>}</xsl:template>


<!-- Move this to springerLatex.xsl since it is specific unless Extrachap is part
 of a regular latex package. -->
<xsl:template match="bibliography">
<xsl:choose>
<xsl:when test="$bibliog.file = ''">
<xsl:message>bibliography file not set (bibliog.file)</xsl:message>
</xsl:when>
<xsl:otherwise>
\clearpage

\Extrachap{Bibliography}
%\addcontentsline{toc}{chapter}{Bibliography}
%\setcounter{secnumdepth}{-1}
%\setcounter{tocdepth}{4}
%\renewcommand{\bibname}{Bibliography}
\renewcommand{\bibname}{}
\addtocontents{toc}{\protect\setcounter{tocdepth}{-1}}
\renewcommand{\bibname}{}
\def\section*#1{\vskip-13em}
\bibliography{<xsl:value-of select="$bibliog.file"/>} 
\bibliographystyle{plain}
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="squote">`<xsl:apply-templates/>'</xsl:template>
<xsl:template match="quote">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="para">
<xsl:apply-templates/>
</xsl:template>
<xsl:template match="para[@noindent='true']">
\noindent<xsl:apply-templates/>
</xsl:template>



<xsl:template match="caption[.//listitem] | caption[count(.//para) > 1]">
\captionsetup{singlelinecheck=off}
\cprotect\caption[<xsl:if test="../title"><xsl:apply-templates select="../title" mode="title"/>,</xsl:if>list=off]{<xsl:apply-templates select="../title" mode="title"/>.  <xsl:apply-templates/>}
<xsl:if test="ancestor::figure/@id">\label{<xsl:value-of select="ancestor::figure/@id"/>}</xsl:if>
</xsl:template>

<xsl:template match="example">
\begin{Example}{<xsl:apply-templates select="./title" mode="eg"/>}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}%</xsl:if>
<!--\begin{example}\cprotect\caption{<xsl:apply-templates select="./title" mode="eg"/>}\end{example}-->
\noindent <xsl:apply-templates /><!-- select="*[not(name() = 'title')] | text()"/> -->
\end{Example}
</xsl:template>


<xsl:template match="XXX_example">
\begin{MyExample}[H]
\caption[A false title]{}
This is my example.
\end{MyExample}
<!--\begin{Example}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if>
\cprotect\caption{<xsl:apply-templates select="./title" mode="eg"/>}
<xsl:apply-templates />
\end{Example}-->
</xsl:template>



<xsl:template match="example/title"/>
<xsl:template match="example/title" mode="eg"><xsl:apply-templates/></xsl:template>

<!--  \section  -->
<!--  <xsl:call-template name="makeheading"/>  -->
<xsl:template match="section[./title/*]">
\section[<xsl:apply-templates select="./title/text()"/>]{<xsl:apply-templates select="./title/*|./title/text()"/>}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if><xsl:apply-templates />					
</xsl:template>

<xsl:template match="section[./title/*]">
<xsl:call-template name="makeheading">
<xsl:with-param name="level" select="count(ancestor::section)+1"/>
</xsl:call-template><!--<xsl:if test="@id">\Ourlabel{<xsl:value-of select="@id"/>}</xsl:if>--><xsl:apply-templates />
</xsl:template>



<xsl:template match="appendix[./title/*]">
  <xsl:if test="not (preceding-sibling::appendix)">
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>% Appendixes start here&#10;</xsl:text>
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>\begin{appendices}&#10;</xsl:text> 
    <xsl:text>\appendix&#10;</xsl:text>
  </xsl:if>
\section[<xsl:apply-templates select="./title/text()"/>]{<xsl:apply-templates select="./title/*|./title/text()"/>}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if><xsl:apply-templates />					

  <xsl:if test="not (following-sibling::appendix)">
    <xsl:text>&#10;\end{appendices}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- See below -->
<xsl:template match="graphic">
%\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="@fileref"/></xsl:with-param></xsl:call-template>}
</xsl:template>


<xsl:template match="graphic[contains(@fileref, '.svg')]">
%\includegraphics{<xsl:call-template name="makeFileRef"><xsl:with-param name="path"><xsl:value-of select="substring-before(@fileref, '.svg')"/>.png</xsl:with-param></xsl:call-template>}
</xsl:template>

<!-- XXXXX -->

<xsl:template match="graphic">
\includegraphics[width=\textwidth]{<xsl:call-template name="nmakeFileRef"/>}
</xsl:template>

<xsl:template match="graphic[@ltx:width]">
\includegraphics[width=<xsl:value-of select="@ltx:width"/>]{<xsl:call-template name="nmakeFileRef"/>}
</xsl:template>


<xsl:template match="graphic[contains(@fileref, '.svg')]">
\includegraphics[width=\textwidth]{<xsl:call-template name="nmakeFileRef"><xsl:with-param name="filename"><xsl:value-of select="substring-before(@fileref, '.svg')"/></xsl:with-param></xsl:call-template>.png}
</xsl:template>



<xsl:template match="graphic[contains(@fileref, '.jpg')]">
\includegraphics[width=\textwidth]{<xsl:call-template name="nmakeFileRef"></xsl:call-template>}
</xsl:template>

<xsl:template name="nmakeFileRef">
<xsl:param name="filename" select="@fileref"/>
<xsl:call-template name="xml.base.dirs"><xsl:with-param name="base.elem" select="."/></xsl:call-template><xsl:call-template name="strippath"><xsl:with-param name="filename" select="$filename"/></xsl:call-template>
</xsl:template>


<!--
<xsl:template match="text()[ancestor::caption]">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>
-->



<!-- See below. -->
<xsl:template match="programlisting">\begin{CodeChunk}
\begin{CodeInput}
<xsl:apply-templates />
\end{CodeInput}
\end{CodeChunk}
</xsl:template>


<xsl:template name="verbatimOptions">
<xsl:if test="not($programlisting.style = '') or @ltx:fontsize"><xsl:text>[</xsl:text>
 <xsl:value-of select="$programlisting.style"/>
 <xsl:if test="@ltx:fontsize">
  <xsl:if test="not($programlisting.style = '')">,</xsl:if>
  <xsl:text>fontsize=</xsl:text><xsl:value-of select="@ltx:fontsize"/>
</xsl:if>]</xsl:if>
</xsl:template>

<!-- <xsl:message>adding new line to <xsl:value-of select="substring(., 0, 20)"/></xsl:message> -->
<xsl:template name="removeVerbatimStartNewline">
<xsl:if test="not(starts-with(., '&#10;'))"><xsl:text>&#10;</xsl:text></xsl:if><!--<xsl:text>&#10;</xsl:text>-->
</xsl:template>

<!-- fontsize=\relsize{-2} add a comment -->
<xsl:template match="programlisting">\begin{Verbatim}<xsl:call-template name="verbatimOptions"/>
<xsl:call-template name="removeVerbatimStartNewline"/>
<xsl:apply-templates />
<xsl:if test="not(substring(., string-length(.)) = '&#10;')"><xsl:text>&#10;</xsl:text></xsl:if>\end{Verbatim}
</xsl:template>


<xsl:template match="programlisting[.//co | .//highlight]">\begin{alltt}<xsl:call-template name="removeVerbatimStartNewline"/>
<xsl:apply-templates />\end{alltt}</xsl:template>


<xsl:template match="orderedlist">
\begin{enumerate}<xsl:call-template name="orderedListFormat"/>
<xsl:apply-templates />
\end{enumerate}
</xsl:template>

<xsl:template name="orderedListFormat">
<xsl:if test="@numeration">[<xsl:if test="@numeration = 'lowerroman'">i</xsl:if>]</xsl:if>
</xsl:template>


<xsl:template match="note">
\begin{quote}
 Note: <xsl:apply-templates/>
\end{quote}
</xsl:template>


<xsl:template match="biblioref">\<xsl:value-of select="$default.cite.cmd"/>{<xsl:value-of select="@linkend"/>}</xsl:template>
<!-- Not certain why match="citation/biblioref" doesn't work -->
<xsl:template match="citation[biblioref]">\<xsl:value-of select="$default.cite.cmd"/>{<xsl:value-of select="biblioref/@linkend"/>}</xsl:template>

<!-- Allow multiple biblioref nodes within a single citation and put them into a \cite{a,b,c} -->
<xsl:template match="citation[count(biblioref) > 1]">\<xsl:value-of select="$default.cite.cmd"/>{<xsl:for-each select="biblioref"><xsl:value-of select="@linkend"/><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>}</xsl:template>

<xsl:template match="fix|check"/>

<xsl:template match="sup">$^{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sub">$_{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="title/subtitle">\\<xsl:text>&#10;</xsl:text><xsl:apply-templates/></xsl:template>

<xsl:template match="dso">\DSO{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="proj">\Project{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r:na">\texttt{NA}</xsl:template>

<xsl:template match="directory|dir">\texttt{<xsl:apply-templates/>/}</xsl:template>

<xsl:template match="lib">\DLL{<xsl:apply-templates/>/}</xsl:template>


<xsl:template match="markupLang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>

