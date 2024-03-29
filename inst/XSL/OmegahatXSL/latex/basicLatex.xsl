<xsl:stylesheet 
	exclude-result-prefixes="doc str" version='1.0'
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
        xmlns:xp="http://www.w3.org/TR/xpath"
        xmlns:c="http://www.C.org"
        xmlns:make="http://www.make.org"
        xmlns:sql="http://www.sql.org"
        xmlns:sh="http://www.shell.org">

<xsl:import href="dblatex.xsl"/>

<xsl:include href="xpath.xsl"/>
<xsl:include href="js.xsl"/>

<xsl:include href="c.xsl"/>
<xsl:include href="py.xsl"/>

<!--<xsl:include href="languages.xsl"/>-->
<xsl:include href="latex.xsl"/>
<xsl:include href="entities.xsl"/>

<xsl:include href="../common/fileRefs.xsl"/>
<xsl:include href="svg.xsl"/>
<xsl:include href="xml.xsl"/>

<xsl:include href="table.xsl"/>

<xsl:include href="sh.xsl"/>
<xsl:include href="sql.xsl"/>
<xsl:include href="xsl.xsl"/>

<xsl:include href="regex.xsl"/>


<xsl:template match="em">\textit{<xsl:apply-templates/>}</xsl:template>



<xsl:output method="text" omit-xml-declaration="yes"/>

<xsl:param name="use.code.marginnote.identifiers" select="false"/>
<xsl:param name="latex.macro.file">latexMacros</xsl:param>
<xsl:param name="load.cprotect" select="1"/>
<xsl:param name="protect.captions" select="true"/>
<xsl:param name="newline.before.caption" select="true"/>

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

<!--  Try to identify paragraphs that are sloppy -->
<xsl:template match="para[@sloppy] | para[.//ulink[string-length(.) > 25]] | para[not(ancestor::title) and count(.//xml:tag) > 2] | para[ .//r:class[string-length(.) > 9] and not(ancestor::summary)]">\begin{sloppy}<xsl:if test="parent::example and count(preceding-sibling::para) = 0">\noindent</xsl:if><xsl:apply-imports/>\end{sloppy}
</xsl:template>
<!-- \hskip-\parindent -->


<xsl:template name="verbName">
<xsl:choose>
<xsl:when test="ancestor::table">verb</xsl:when>
<xsl:otherwise>verb</xsl:otherwise>			       <!--Was PVerb[], PVerb, prior to that spverb -->
<!--
<xsl:otherwise>
  <xsl:choose>
    <xsl:when test="ancestor::varlistentry">PVerb</xsl:when>
  </xsl:choose>
</xsl:otherwise>
-->
</xsl:choose>
</xsl:template>


<xsl:template match="comment()"/>
<xsl:template match="comment() | invisible | ignore">% <xsl:call-template name="forceBreakIf"/></xsl:template>
<!-- <xsl:template match="comment()[name( (./preceding-sibling::* | ./preceding-sibling::text())[1] ) = 'code']"><xsl:call-template name="forceBreakIf"/></xsl:template> -->
<xsl:template match="comment()[following-sibling::figure]">%<xsl:text>&#10;</xsl:text></xsl:template>

<xsl:template match="caption//comment()">%
</xsl:template>

<xsl:template match="extension">\textsl{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="protocol">\protocol{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="matlab">\proglang{MATLAB}\textregistered\index{MATLAB@\proglang{MATLAB}\textregistered}</xsl:template>
<xsl:template match="fop">\ShApp{FOP}</xsl:template>

<xsl:template match="trademark">\texttrademark</xsl:template>

<xsl:template match="gearth">Google Earth\texttrademark\index{Google Earth\texttrademark}</xsl:template>



<!--  See if we can use the "scape" template and defaults in dblatex. -->
<xsl:template name="textReplace" match="text()[(not(ancestor::ltx:math) and not(ancestor::c:code) and
					not(ancestor::r:function) and not(ancestor::r:code) and not(ancestor::r:output)
					and not(ancestor::xml:code) and not(ancestor::js:code) and
					not(ancestor::svg:code) and not(ancestor::programlisting) and
					not(ancestor::literal) and not(ancestor::r:class) and not(ancestor::sh:code) and
					not(ancestor::ulink) and not(ancestor::sql:code) and not(sh:code) and
					not(ancestor::r:plot) and not(parent::math) and not(parent::displaymath)) and
					not(ancestor::sql:output) and not(ancestor::sh:output)]">
<xsl:param name="xstr" select="string(.)"/>
<!-- <xsl:message>textReplace: <xsl:value-of select="$xstr"/></xsl:message> -->
<xsl:value-of select="str:replace(str:replace(str:replace(str:replace(str:replace(str:replace(str:replace(str:replace(str:replace($xstr, '&amp;', '\&amp;'), '_', '\_'), '#', '\#'), '%', '\%'), '{', '\lcurly'), '}', '\rcurly'), '$', '\$'), '\\', '\\\\'), ' - ', ' -- ')"/></xsl:template>


<!-- <xsl:template match="text()[ancestor::r:class[@escape='true']]"><xsl:value-of select="str:replace(., '{', '\{')"/></xsl:template> -->


<xsl:template match="text()[ancestor::programlisting or ancestor::xp:expr or ancestor::r:code or ancestor::r:output or ancestor::r:function or ancestor::xsl:code or ancestor::make:code or ancestor::literal or ancestor::sql:code or ancestor::r:plot]">
<xsl:copy select="."/></xsl:template>

<xsl:template match="example/para[position() = 1]/text()[1][starts-with(., '&#10;')] | callout/para[position() = 1]/text()[1][starts-with(., '&#10;')] | formalpara/para[position() = 1]/text()[1][starts-with(., '&#10;')]" priority="1000">
<!--<xsl:message>text() inside an example that starts with a new-line: <xsl:value-of select="string(.)"/></xsl:message>-->
<xsl:variable name="foo"><xsl:call-template name="textReplace"/></xsl:variable>
<xsl:value-of select="substring($foo, 2)"/>
</xsl:template>



<xsl:template name="replace-leading-newlines">
<xsl:param name="string"/>
<xsl:choose><xsl:when test="substring($string, 1, 1) = '&#10;'"> <!-- or substring($string, 1, 1) = ''-->
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
<xsl:message>Thanks for calling /article</xsl:message>
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

<xsl:if test="(//caption//r:expr | //caption//r:formula | //caption//xp:expr) or $load.cprotect > 0">
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

\usepackage{spverbatim}

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
<xsl:if test="//r:expr|//r:formula|//xp:expr">\cprotect</xsl:if>\caption{<xsl:apply-templates/>}
<xsl:if test="ancestor::figure/@id">\label{<xsl:value-of select="ancestor::figure/@id"/>}</xsl:if>
</xsl:template>


<xsl:template match="figure[title]/caption">
<xsl:if test="$newline.before.caption"><xsl:text>&#10;</xsl:text></xsl:if>
<xsl:if test="$protect.captions | @ltx:protect | .//r:expr|.//r:formula|.//xp:expr|.//literal|.//title|../title//r:expr|../title//r:formula|../title/xp:expr|../title//literal">\cprotect</xsl:if>\caption[<xsl:apply-templates select="../title" mode="title"/>]{<xsl:apply-templates select="../title" mode="title"/><xsl:if test="not(substring(normalize-space(title), string-length(normalize-space(title))) =  '.')">.  </xsl:if>{\itshape <xsl:apply-templates/>}}
<xsl:if test="ancestor::figure/@id">\label{<xsl:value-of select="ancestor::figure/@id"/>}</xsl:if>
</xsl:template>



<xsl:template match="dyngraphic"/>
<xsl:template match="comment"/>



<xsl:template match="r:slot">\Rslot{<xsl:apply-templates/>}</xsl:template>






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

<!-- 
\@writefile{loe}{\contentsline {example}{\numberline {1.1}{\ignorespaces <xsl:apply-templates select="title"/>}}{8}{figure.caption.3}}
 -->
<!-- \numberline{\theExample} -->
<xsl:template match="example">
\message{EXAMPLE <xsl:value-of select="@id"/>^^J}
\begin{Example}{<xsl:apply-templates select="./title" mode="eg"/>}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}%</xsl:if>
\addcontentsline{ex}{Example}{\protect\numberline{\thesExampleCounter} <xsl:apply-templates select="title" mode="exampleTitle"/>}
\noindent
<xsl:apply-templates />

\end{Example}
</xsl:template>

<xsl:template match="title" mode="exampleTitle"><xsl:apply-templates/></xsl:template>


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
<xsl:template match="section[./title/*]">
<xsl:message>section with a title with markup</xsl:message>
\section[<xsl:apply-templates select="./title/text()"/>]{<xsl:apply-templates select="./title/*|./title/text()"/>}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if><xsl:apply-templates />					
</xsl:template>

<xsl:template match="section[./title/*]">
<xsl:call-template name="makeheading">
<xsl:with-param name="level" select="count(ancestor::section)+1"/>
</xsl:call-template><!--<xsl:if test="@id">\Ourlabel{<xsl:value-of select="@id"/>}</xsl:if>--><xsl:apply-templates />
</xsl:template>

<xsl:template match="section[./altTitle]">
<xsl:call-template name="map.sect.level">
  <xsl:with-param name="level" select="count(ancestor::section)+1"/>
<!--  <xsl:with-param name="name" select=""/>
  <xsl:with-param name="num" select=""/>
  <xsl:with-param name="allnum" select="$allnum"/>-->
</xsl:call-template>[<xsl:apply-templates select="altTitle" mode="toc"/>]<xsl:apply-templates select="./title" mode="format.title"/><xsl:call-template name="label.id"/><xsl:apply-templates />
</xsl:template>

<xsl:template match="altTitle"/>
<xsl:template match="altTitle" mode="toc">
<xsl:apply-templates/>
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
\includegraphics[width=\textwidth<xsl:for-each select="@*[namespace-uri() = 'http://www.latex.org']"><xsl:message><xsl:value-of select="name()"/></xsl:message>,<xsl:value-of select="local-name(.)"/>=<xsl:value-of select="."/><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]{<xsl:call-template name="nmakeFileRef"/>}
</xsl:template>

<xsl:template match="graphic[@ltx:width]">
\includegraphics[width=<xsl:value-of select="@ltx:width"/><xsl:if test="@ltx:height">,height=<xsl:value-of select="@ltx:height"/></xsl:if>]{<xsl:call-template name="nmakeFileRef"/>}
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
\end{Verbatim}
<xsl:call-template name="forceBreakIf"/>
</xsl:template>

<xsl:template match="programlisting"><xsl:call-template name="makeCodeEnv"/></xsl:template>


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


<xsl:template match="note|aside">
\begin{quote}
 Note: <xsl:apply-templates/>
\end{quote}
</xsl:template>

<!--
<xsl:template match="text()[(. = ' ' or . = '&#10;') and following-sibling::citation]">
<xsl:message>trimming before citation</xsl:message>
<xsl:call-template name="textReplace"><xsl:with-param name="str"><xsl:call-template name="trim-right"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template></xsl:with-param></xsl:call-template>
</xsl:template>
-->

<xsl:template match="biblioref">\<xsl:value-of select="$default.cite.cmd"/>{<xsl:value-of select="@linkend"/>}</xsl:template>
<!-- Not certain why match="citation/biblioref" doesn't work -->
<xsl:template match="citation[biblioref]">~\<xsl:value-of select="$default.cite.cmd"/>{<xsl:value-of select="biblioref/@linkend"/>}</xsl:template>

<!-- Allow multiple biblioref nodes within a single citation and put them into a \cite{a,b,c} -->
<xsl:template match="citation[count(biblioref) > 1]">~\<xsl:value-of select="$default.cite.cmd"/>{<xsl:for-each select="biblioref"><xsl:value-of select="@linkend"/><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>}</xsl:template>

<xsl:template match="fix|check"/>

<xsl:template match="sup">$^{<xsl:apply-templates/>}$</xsl:template>
<xsl:template match="sub">$_{<xsl:apply-templates/>}$</xsl:template>

<xsl:template match="title/subtitle">\\<xsl:text>&#10;</xsl:text><xsl:apply-templates/></xsl:template>


<xsl:template match="r:na">\texttt{NA}</xsl:template>
<xsl:template match="r:nan">\texttt{NaN}</xsl:template>
<xsl:template match="r:level">\Rlevel{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="ltx:math|math">$<xsl:apply-templates/>$</xsl:template>
<xsl:template match="math[ancestor::programlisting or ancestor::caption]">\(<xsl:apply-templates/>\)</xsl:template>
<xsl:template match="displaymath">$$<xsl:apply-templates/>$$
</xsl:template>

<xsl:template match="text()[parent::math or parent::displaymath]"><xsl:copy-of select="."/></xsl:template>


<xsl:template match="para/title">\textbf{<xsl:apply-templates/>} </xsl:template>


<xsl:template match="r:attr">\RAttr{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="r:el|r:field">\REl{<xsl:apply-templates/>}</xsl:template>

</xsl:stylesheet>

