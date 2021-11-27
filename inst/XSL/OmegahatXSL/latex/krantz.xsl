<xsl:stylesheet
        version='1.0'    
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:r="http://www.r-project.org"
	xmlns:omg="http://www.omegahat.org"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:ltx="http://www.latex.org"
        xmlns:xp="http://www.w3.org/TR/xpath"
        xmlns:http="http://www.w3.org/Protocols"
	xmlns:ubi="http://ubietylab.net/ubigraph/"
	xmlns:sqlite="http://sqlite.org"
	xmlns:lldb="http://www.llvm.org/lldb"
	xmlns:py="http://www.python.org"
	xmlns:git="https://git-scm.com"
        xmlns:s3="http://www.r-project.org"
        xmlns:sql="http://www.sql.org"
        xmlns:c="http://www.C.org"
	xmlns:sh="http://www.shell.org"
        xmlns:str="http://exslt.org/strings"
	xmlns:bioc="http://www.bioconductor.org">

  <!-- 
    Unneeded:

        xmlns:s="http://cm.bell-labs.com/stat/S4"	
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xmlns:svg="http://www.w3.org/2000/svg" 
	xmlns:js="http://www.ecma-international.org/publications/standards/Ecma-262.htm"
	xmlns:saxon="http://icl.com/saxon"
 -->

  
<xsl:include href="http://www.omegahat.org/XSL/latex/basicLatex.xsl"/>
<!--<xsl:include href="http://www.omegahat.org/XSL/latex/languages.xsl"/>-->

<!-- <xsl:include href="latex.xsl"/> -->
<!-- <xsl:include href="extensions.xsl"/> -->

<xsl:output method="text" omit-xml-declaration="yes"/>

<xsl:strip-space elements="summary r:expr programlisting"/>

<xsl:param name="multi.index" select="0"/>

<xsl:param name="use.code.marginnote.identifiers" select="false"/>
<xsl:param name="doc.layout">mainmatter frontmatter toc index</xsl:param>
<!-- Show the list of examples too -->
<xsl:param name="doc.lot.show">figure,table,example</xsl:param>
<xsl:param name="figure.default.position">[hbp]</xsl:param>

<xsl:param name="bibliog.file"></xsl:param>

<xsl:param name="size.preamble"></xsl:param>

<xsl:param name="date"></xsl:param>

<xsl:param name="use.tcboppbox" select="true"></xsl:param>

<xsl:param name="code.line.numbers" select="true"></xsl:param>

<xsl:param name="book.macros">bookMacros</xsl:param> 

<!--
<xsl:template match="*"><xsl:message>No template for <xsl:value-of select="local-name()"/> in <xsl:value-of select="ancestor::chapter/@id"/></xsl:message></xsl:template>
-->


<xsl:template match="rcbrace">\}</xsl:template>
<xsl:template match="lcbrace">\{</xsl:template>

<xsl:template match="param"><http:arg><xsl:apply-templates/></http:arg></xsl:template>

<xsl:template match="http:arg">\httpArg{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="libcairo">\DLL{cairo}</xsl:template>

<xsl:template match="http:headerLine">\HTTPHeaderLine{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="xsltproc">\ShApp{xsltproc}</xsl:template>

<xsl:template match="dquote">``<xsl:apply-templates/>''</xsl:template>

<xsl:template match="cdata">\XMLKeyword{CDATA}</xsl:template>
<xsl:template match="pi">\XMLKeyword{PI}</xsl:template>


<xsl:template match="index">
\printindex
</xsl:template>

<xsl:template match="colophon">
\chapter*{Colophon}
\addcontentsline{toc}{chapter}{Colophon}

<xsl:apply-templates/>
</xsl:template>

<xsl:template match="dedication">
\cleardoublepage
\thispagestyle{empty}
\vspace*{\stretch{1}}
\begin{center}
<xsl:apply-templates/>
\end{center}
\vspace{\stretch{2}}
</xsl:template>

<xsl:template match="formalpara">\vskip .5em\noindent {\textbf{<xsl:apply-templates select="./title/* | ./title/text()"/>}}\hfill\break <xsl:apply-templates />
</xsl:template>

<xsl:template match="entry/formalpara">\message{TABLE-FORMALPARA <xsl:value-of select="string(title)"/>^^J}
<xsl:if test="preceding-sibling::formalpara"><xsl:message>newline for <xsl:value-of select="string(title)"/></xsl:message>
<xsl:text>&#10;</xsl:text>
</xsl:if>\noindent {\textbf{<xsl:apply-templates select="./title/* | ./title/text()"/>}}  <xsl:apply-templates />
</xsl:template>

<xsl:template match="section[@silent='true']">
\section*{<xsl:apply-templates select="./title/* | ./title/text()"/>}
<xsl:apply-templates />
</xsl:template>

<xsl:template match="foreword">
\foreword

<xsl:apply-templates/>

\vspace{\baselineskip}
\begin{flushright}\noindent
San Francisco Bay Area, December 2021\hfill 
{\it Matt Espe}\\
{\it Duncan Temple Lang}\\
\end{flushright}
</xsl:template>

<xsl:template match="preface">
\chapter*{Preface}
\begin{bibunit}  
%\addcontentsline{toc}{chapter}{Preface}
%\addtocontents{toc}{\protect\setcounter{tocdepth}{0}}

<xsl:apply-templates/>
%\addtocontents{toc}{\protect\setcounter{tocdepth}{5}}
%\clearpage

\putbib
\end{bibunit}
</xsl:template>

<xsl:template match="preface/section">
\section*{<xsl:apply-templates select="./title/* | ./title/text()"/>}
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="backmatter">
\backmatter
</xsl:template>

<!-- XXX -->
<xsl:template match="chapter/summary">
<xsl:if test="count(para) > 1"><xsl:message>Only processing first paragraph in </xsl:message></xsl:if>
\abstract{<xsl:apply-templates select="para[1]"/>} 
</xsl:template>

<xsl:template match="chapter[bibliography]">
<xsl:call-template name="mapheading"/>
\begin{bibunit}
<xsl:apply-templates/>
\end{bibunit}
</xsl:template>

<xsl:template match="chapter/bibliography">
\section{Further Reading}
<xsl:apply-templates/>

\putbib
</xsl:template>


<xsl:template match="xxx_chapter">
<xsl:message>chapter <xsl:value-of select="@id"/></xsl:message>
\ResetChapter
<xsl:apply-imports/>
</xsl:template>

<xsl:param name="use.crc.packages">
  %\usepackage{fixltx2e}
  %\usepackage{fix-cm}
%\usepackage{amssymb}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{subfigure}
% included below:  \usepackage{makeidx}
\usepackage{multicol}

\usepackage{xcolor}

% If we use these as recommended in the Krantz README file, we get weird characters
% e.g. see second paragraph "each years race" has weird characters.
% This is probably because the character is weird in the XML file, e.g. coming from
% word and being a fancy quote or something
\usepackage[T1]{fontenc}
\usepackage{lmodern}


%\usepackage{draftwatermark}
%\SetWatermarkText{Do Not Distribute}
%\SetWatermarkScale{.70}
\newcounter{ExerciseCounter}[chapter]

</xsl:param>

<xsl:param name="use.packages">
%\usepackage[nocrop]{T4layout}
\usepackage[utf8]{inputenc}

%\usepackage{mathptmx}
\usepackage{helvet}
\usepackage{courier}
%
%
\usepackage{type1cm}         

\usepackage[hyphens]{url}

\usepackage{makeidx}         % allows index generation
%\usepackage[split]{splitidx} % allows index generation
%\makeindex
%\newindex[General Index]{idx}
%\newindex[R Function and Parameter Index]{Rfunc}
%\newindex[R Package Index]{Rpkg}
%\newindex[R Class Index]{Rclass}


%%%%Doesn't work:
%%%% \usepackage{index} % experiment to see if it escapes the contents of \index

\usepackage{graphicx}        % standard LaTeX graphics tool
                             % when including figure files
\usepackage{multicol}        % used for the two-column index
%\usepackage[bottom]{footmisc}% places footnotes at page bottom

%\usepackage{ifxetex}
%\usepackage{Rdocbook}

\usepackage[figurename=Figure]{caption}  % [font=small]
% Uncommenting the next line (captionsetup) causes the entire build to fail!
%\captionsetup[figurename=Figure]
\usepackage{cprotect}  % for verbatim in captions

%\usepackage{enumerate} % for the roman numerals with \begin{enumerate}[i]

\usepackage{color}
\usepackage{supertabular}
\usepackage{tabularx}

%\usepackage[authoryear,round]{natbib}
% chapterbib??
\usepackage[sectionbib,square,comma]{natbib}

%\usepackage{afterpage}

\usepackage{alltt}
%\usepackage{relsize}


\usepackage[neveradjust]{paralist}
%\usepackage{paralist}
       % shortlabels is for the [i] for enumeration types.
%\usepackage[shortlabels]{enumitem} 


\usepackage[globalcitecopy]{bibunits}
% ,citefull=chapter,opcite=chapter,duplicate

\usepackage{marginnote}

\usepackage{float}
%\floatstyle{boxed}
\floatstyle{plaintop}
%\newfloat{MyExample}{H}{lex}[chapter]
%\newfloat{example}{H}{lex}[chapter]
%\usepackage{chngcntr}

%??? Do we need examplep? spverbatim?
\usepackage{examplep}
\usepackage{spverbatim}
\usepackage{textcomp}  % for \lessthan and  texttildelow appearance

\usepackage{mdframed}


% [titles]
%\usepackage{tocloft}
%\setlength{\cftsecnumwidth}{2.6em}
%\newcommand{\listexamplename}{List of Examples}
%\newlistof[chapter]{Example}{ex}{\listexamplename}
%\newlength\mylength
%\settowidth\mylength{ABCDEFGHIJKLM}
%\addtolength\cftExamplenumwidth{\mylength}
%\setlength{\cftExamplenumwidth}{8em}


\usepackage{tikz}
\newcommand*\circled[1]{\tikz[baseline=(char.base)]{
    \node[shape=rectangle,draw,inner sep=1pt,fill=lightgray] (char) {#1};}}


%\usepackage[pdfpagelabels,pdfpagemode=UseOutlines]{hyperref}
\usepackage[pdfpagelabels,pdfusetitle,pdfauthor={DTL},pdfkeywords={R,programming,mastering},pdfsubject={Mastering R}]{hyperref}
% ,pdfpagemode
%\newcommand{\hyperref}[2][2]{#2}
%\def\phantomsection{}
%\hypersetup{bookmarks=true,bookmarksopen=true,bookmarksopenlevel=1}


% For verbatim in the footnotes
\usepackage{fancyvrb}
\VerbatimFootnotes

\usepackage{manfnt}

\usepackage{placeins}

\setcounter{topnumber}{4}
\setcounter{bottomnumber}{4}
\setcounter{totalnumber}{10}
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.70}
\renewcommand{\floatpagefraction}{0.66}


% Trying to deal with marginnote question mark one one page and exercise text on the next.
%\widowpenalty=10000



\usepackage{tikz}
\usepackage{tikz-qtree,tikz-qtree-compat}
\usetikzlibrary{trees}
\usepackage{rotating}

\usepackage{dingbat}

\usepackage[acronym]{glossaries}

</xsl:param>

<xsl:template match="zoe">Zo\"e</xsl:template>

<xsl:template match="glossary">
<!--\Extrachap{Glossary}-->\chapter{Glossary}*<xsl:call-template name="label.id"/>\phantomsection
<xsl:apply-templates select="." mode="section.body"/>

<!-- Being completed. -->

<xsl:call-template name="section.unnumbered.end"/>
</xsl:template>




<xsl:template name="verbatim.setup">
<xsl:message>adding my own packages</xsl:message>
<xsl:value-of select="$use.packages"/>
</xsl:template>

<xsl:template match="book|article" mode="preamble">
  <xsl:param name="lang"/>
  <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>

\documentclass[krantz2,ChapterTOCs]{krantz} %See documentation for other class options
\nonstopmode
<xsl:value-of select="$use.crc.packages"/>
<xsl:value-of select="$use.packages"/>

\frenchspacing
\tolerance=5000
\newif\ifUseMinted

%\include{frontmatter/preamble} %place custom commands and macros here

\setcounter{tocdepth}{6}
\setcounter{secnumdepth}{5}

% see the list of further useful packages
% in the Reference Guide

\makeindex             % used for the subject index
                       % please use the style svind.ist with
                       % your makeindex program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% from Springer (svmult.cls)
%\newcommand{\Extrachap}[1]{\chapter*{#1}\markboth{#1}{#1}%
%\addcontentsline{toc}{chapter}{#1}}
\newcommand{\Extrachap}[1]{\chapter{#1}}


\input{<xsl:value-of select="$book.macros"/>}

%%%%%%%%%%%%

<xsl:apply-templates select="bookinfo/authorgroup"/>
\title{<xsl:apply-templates select="title" mode="title"/>} 
<!-- <xsl:apply-templates select="title" mode="title"/> -->

<xsl:apply-templates select="bookinfo|articleinfo|info" mode="docinfo"/>

<xsl:value-of select="$size.preamble"/>

\def\chaptermark{\markboth{xx TITLE OF BOOK xx (<xsl:value-of select="$timestamp"/>)}} 

</xsl:template>

<!-- XXX FIX to get both. -->
<xsl:template match="bookinfo/authorgroup">
\author{
<xsl:for-each select="author"><xsl:apply-templates select="."/><xsl:if test="not(position() = last())">\\
</xsl:if></xsl:for-each>
}
</xsl:template>						       <!-- %\author{} -->

<xsl:template match="author">
<xsl:apply-templates select="firstname"/><xsl:text> </xsl:text><xsl:if test="othername[@role='mi']"><xsl:value-of select="othername[@role='mi']"/> </xsl:if><xsl:apply-templates select="surname"/>
<xsl:if test="not(ancestor::article)">\\</xsl:if>
<xsl:if test="ancestor::article">, </xsl:if>
<xsl:apply-templates select="affiliation"/>
</xsl:template>

<xsl:template match="page"><xsl:message>Emitting a clearpage</xsl:message>\clearpage
</xsl:template>


<!-- reuse the templates in dblatex -->
<xsl:template match="book/title"><xsl:apply-templates/></xsl:template>

<xsl:template match="ltx:cmd">\TeXCmd{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="programlisting[@contentType='JSON' or @contentType='json']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">JSONCode</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="programlisting[@contentType='HTTP' or @contentType='http']">
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">HTTPCode</xsl:with-param></xsl:call-template>
</xsl:template>





<!-- Make certain new lines in an r:expr, don't get through. -->
<xsl:template match="xxx_literal/text()|xp:expr/text()|r:expr/text()|r:formula/text()|r:errorMsg/text()">
<xsl:call-template name="textReplace"><xsl:with-param name="xstr"><xsl:value-of select="translate(string(.),'&#x0A;',' ')"/></xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="literal[contains(., '%') and ancestor::table]">\texttt{<xsl:value-of select="str:replace(translate(string(.),'&#x0A;',' '), '%', '\%')"/>}</xsl:template>




<xsl:template match="literal">\<xsl:call-template name="verbName"/>|<xsl:apply-templates/>|</xsl:template>
<!-- <xsl:template match="literal[ancestor::term and ancestor::varlistentry]">\PVerb{<xsl:apply-templates/>}</xsl:template> -->
<xsl:template match="literal">\verb|<xsl:apply-templates/>|</xsl:template>
<xsl:template match="literal[contains(., '|')]">\verb#<xsl:apply-templates/>#</xsl:template>

<xsl:template match="title//literal">\texttt{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="literal[contains(string(.), '%')]">\<xsl:call-template name="verbName"/>|<xsl:call-template name="string-replace">
<xsl:with-param name="string"><xsl:value-of select="string(.)"/></xsl:with-param>
<xsl:with-param name="from">%</xsl:with-param>
<xsl:with-param name="to">\%</xsl:with-param>
</xsl:call-template>|</xsl:template>



<!-- Take Windows style paths and escape the \ into \\ -->
<xsl:template match="filename[contains(string(.), '&#x5c;')]">
\nolinkurl{<xsl:call-template name="string-replace">
 <xsl:with-param name="string"><xsl:value-of select="str:replace(string(.), '~', '\(\sim \)')"/></xsl:with-param>
 <xsl:with-param name="from">\</xsl:with-param>
 <xsl:with-param name="to">\\</xsl:with-param>
</xsl:call-template>}
</xsl:template>



<!--  (c) David Carlisle
      replace all occurences of the character(s) `from'
      by the string `to' in the string `string'.
  -->
<xsl:template name="string-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:choose>
    <xsl:when test="contains($string,$from)">
      <xsl:value-of select="substring-before($string,$from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="string-replace">
        <xsl:with-param name="string" select="substring-after($string,$from)"/>
        <xsl:with-param name="from" select="$from"/>
        <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="figure">
\message{FIGURE^^J}
  <xsl:text>\begin{</xsl:text><xsl:if test="@sideways"><xsl:text>sideways</xsl:text></xsl:if><xsl:text>figure}</xsl:text><xsl:if test="not(title)"><xsl:call-template name="label.id"/></xsl:if>
  <!-- figure placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:when test="(@float and @float='0')">
      <xsl:text>[H]</xsl:text>
    </xsl:when>
    <xsl:otherwise><!--<xsl:message>using default figure position (<xsl:value-of select="$figure.default.position"/>) for <xsl:value-of select="@id"/></xsl:message>-->
      <xsl:value-of select="$figure.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
  <!-- title caption before the image -->
  <xsl:if test="$figure.title.top = '1'">
    <xsl:apply-templates select="title"/>
  </xsl:if>
  <!--
  <xsl:text>&#10;\centering&#10;</xsl:text>
  -->
  <!-- Turn off for production/final version. Only to help us remember the id so we can reference it in the xml  -->
  \marginnote{{\MarginLangBox{\tiny{<xsl:value-of select="translate(@id, '_', '.')"/>}}}}
<!--  Quick attempt to show the name of the image in the figure.  Issue with escaping the _
  \marginnote{{\MarginLangBox{\tiny{\verb+<xsl:value-of select="graphic/@fileref"/>+}}}}[1cm] -->
  <xsl:text>&#10;\begin{center}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>&#10;\end{center}&#10;</xsl:text>
  <!-- title caption after the image -->
  <xsl:if test="$figure.title.top != '1'">
    <xsl:apply-templates select="title"/>
  </xsl:if>
  <xsl:text>\end{</xsl:text><xsl:if test="@sideways"><xsl:text>sideways</xsl:text></xsl:if><xsl:text>figure}&#10;</xsl:text>
</xsl:template>

<xsl:template match="caption[../figure]">\textit{<xsl:apply-templates/>}</xsl:template>

<!-- This doesn't seem to be used anymore. Do we not have any xrefs to sidebars. -->
<!--
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Sidebar'"/>
  </xsl:call-template>
-->
<xsl:template match="sidebar" mode="xref-to">
page \pageref{<xsl:value-of select="@id"/>}</xsl:template>

<!-- text for reference to a paragraph -->
<xsl:template match="para" mode="xref-to">
  <!--   <xsl:text>page</xsl:text> -->
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'page'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="sq">``</xsl:template>
<xsl:template match="eq">''</xsl:template>
<xsl:template match="qt">``<xsl:apply-templates/>''</xsl:template>

<xsl:template match="lt">$&lt;$</xsl:template>

<xsl:template match="q" mode="xref-to">
<xsl:param name="referrer"/>
<xsl:param name="xrefstyle"/>
<xsl:text>Q</xsl:text><xsl:message>q (xref-to) <xsl:value-of select="local-name(.)"/> , <xsl:value-of select="$referrer"/></xsl:message>
</xsl:template>

<xsl:template match="functionSummaryTable" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>
<xsl:message>xref for functionSummaryTable: referrer= <xsl:value-of select="$referrer"/>, style= <xsl:value-of select="$xrefstyle"/></xsl:message>
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Table'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="functionSummaryTable">
<!-- <xsl:apply-templates select="title"/> -->
\begin{sloppy}
\begin{description}
<xsl:apply-templates select=".//tbody/row"/>
\end{description}
\end{sloppy}
</xsl:template>



<xsl:template match="calloutlist">			       <!-- [.//para[@sloppy]] -->
\begin{sloppy}<xsl:apply-imports/>\end{sloppy}
</xsl:template>

<xsl:template match="calloutlist">
<xsl:variable name="cmd"><xsl:choose><xsl:when test="@ltx:tableType"><xsl:value-of select="@ltx:tableType"/></xsl:when><xsl:otherwise>supertabular</xsl:otherwise></xsl:choose></xsl:variable>
<!-- .97 gives 8 overfull \hbox'es  out of 12.
   .965 gives 2 overfull \hbox'es
   .96 removes all.
 -->
<xsl:variable name="width"><xsl:choose><xsl:when test="@ltx:width"><xsl:value-of select="@ltx:width"/></xsl:when><xsl:otherwise>.96</xsl:otherwise></xsl:choose></xsl:variable>
% calloutlist
\message{CALLOUT LIST^^J}
\noindent
\begin{<xsl:value-of select="$cmd"/>}{@{}lp{<xsl:value-of select="$width"/>\textwidth}}
<xsl:apply-templates select="callout"/>
\end{<xsl:value-of select="$cmd"/>}
\nopagebreak\vspace{1em}
</xsl:template>
<!-- \vspace{1em}\HRule -->

<xsl:template match="callout">
<xsl:variable name="idx" select="position()"/>
<xsl:variable name="lab" select="ancestor::calloutlist/preceding-sibling::*/co[$idx]/@id"/>
\phantomsection\hyperref[<xsl:value-of select="$lab"/>]{\circled{<xsl:value-of select="position()"/>}}\label{<xsl:value-of select="$lab"/>_txt} &amp;
 <xsl:apply-templates /> \\
</xsl:template>



<xsl:template match="part">
\part{<xsl:apply-templates select="title"/>}
<xsl:apply-templates select="*[not(local-name() = 'title')] | text()"/>
</xsl:template>

<xsl:template match="part/title">
<!--<xsl:message>part/title <xsl:value-of select="string(.)"/></xsl:message>-->
<xsl:apply-templates/>
</xsl:template>

<!-- <xsl:template match="partIntro">\Extrachap{Overview}</xsl:template> -->
<xsl:template match="partIntro">\chapter*{Overview}</xsl:template>
<xsl:template match="partIntro"/>

<!-- Handle the <br/> in a part to put dash in the TOC, but a new line in the text  -->
<xsl:template match="part/title[br]" mode="format.title">[<xsl:apply-templates select="./*|./text()" mode="foo"/>]<xsl:apply-imports/></xsl:template>
<xsl:template match="*" mode="foo"><xsl:apply-templates/></xsl:template>
<xsl:template match="br" mode="foo"> -- </xsl:template>

<xsl:template match="functionSummaryTable//tbody/row">
<xsl:text>
\item[{\FuncSummaryName{</xsl:text><xsl:apply-templates select="entry[1]"/><xsl:text>}}] </xsl:text>
   <xsl:apply-templates select="entry[2]"/>
</xsl:template>

<xsl:template match="chapter//bibliography//biblioentry"/>
<xsl:template match="/*/bibliography"/>

<!-- \sindex[Rpkg|Rclass|Rfunc] based on node name
  check multi.index
 -->
<xsl:template name="callIndex">\index</xsl:template>

<xsl:template match="s3:class[not(@index = 'false')] | r:class[not(@index = 'false')] | r:s3class[not(@index = 'false')]">
<xsl:apply-imports/><xsl:if test="not(ancestor::title) and not(ancestor::caption) and not(ancestor::summary)"><xsl:call-template name="callIndex"/>{<xsl:value-of select="."/>@\S3class{<xsl:value-of select="str:replace(., '_', '\_')"/>}}</xsl:if></xsl:template>
<!-- The ! was _ in both places. -->

<xsl:template match="r:func[not(@index = 'false')]"><xsl:apply-imports/><xsl:if test="not(ancestor::title) and not(ancestor::caption) and not(ancestor::summary) and not(ancestor::footnote)"><xsl:call-template name="callIndex"/>{<xsl:value-of select="str:replace(.,'%','\%')"/>@<xsl:call-template name="RfunctionMarkup"/>{<xsl:value-of select="str:replace(str:replace(translate(., '&lt;-', ''), '_', '\_'), '%', '\%')"/>}}</xsl:if></xsl:template>

<xsl:template match="r:pkg[not(@index = 'false')] | omg:pkg[not(@index = 'false')] | bioc:pkg[not(@index = 'false')]">
<xsl:apply-imports/><xsl:if test="not(ancestor::title) and not(ancestor::caption) and not(ancestor::summary)"><xsl:call-template name="callIndex"/>{<xsl:value-of select="."/>@\pkg{<xsl:value-of select="str:replace(., '_', '\_')"/>}}</xsl:if></xsl:template>

<xsl:template match="omg:pkg[. = 'XML']">
<xsl:apply-imports/><xsl:if test="not(ancestor::title) and not(ancestor::caption) and not(ancestor::summary)"><xsl:call-template name="callIndex"/>{XML@\pkg{<xsl:value-of select="str:replace(., '_', '\_')"/>}}</xsl:if></xsl:template>


<xsl:template match="r:code/text() | sh:code/text() | prompt/text()">
<xsl:call-template name="trim-right"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template><xsl:text>
</xsl:text></xsl:template>

<xsl:template match="r:code | r:console"><xsl:apply-templates/></xsl:template>

<xsl:template match="r:code/r:output"><xsl:if test="preceding-sibling::text() and not(substring(preceding-sibling::text(), (preceding-sibling::text())) = '&#10;')"><xsl:text>&#10;</xsl:text></xsl:if><xsl:if test="$use.tcboppbox">\begin{tcboppbox}
</xsl:if>\begin{ROutput}<xsl:if test="@size">[fontsize=\<xsl:value-of select="@size"/>]</xsl:if>
<xsl:if test="not(starts-with(string(.),'&#10;'))">x&#10;</xsl:if>
<xsl:apply-templates/><!--<xsl:call-template name="trim-newlines"><xsl:with-param name="string" select="string(.)"/></xsl:call-template>-->\end{ROutput}<xsl:if test="$use.tcboppbox">
\end{tcboppbox}</xsl:if><xsl:if test="following-sibling::*[1] or (not(position() = last()) and following-sibling::text() and not(following-sibling::text() = '&#10;'))"><xsl:text>&#10;</xsl:text></xsl:if></xsl:template>

<xsl:template match="r:code/r:error"><xsl:if test="preceding-sibling::text() and not(substring(preceding-sibling::text(), (preceding-sibling::text())) = '&#10;')"><xsl:text>&#10;</xsl:text></xsl:if><xsl:if test="$use.tcboppbox">\begin{tcboppbox}
</xsl:if>\begin{RError}<xsl:if test="@size">[fontsize=\<xsl:value-of select="@size"/>]</xsl:if>
<xsl:if test="not(starts-with(string(.),'&#10;'))">x&#10;</xsl:if>
<xsl:apply-templates/><!--<xsl:call-template name="trim-newlines"><xsl:with-param name="string" select="string(.)"/></xsl:call-template>-->\end{RError}<xsl:if test="$use.tcboppbox">
\end{tcboppbox}</xsl:if><xsl:if test="following-sibling::*[1] or (not(position() = last()) and following-sibling::text() and not(following-sibling::text() = '&#10;'))"><xsl:text>&#10;</xsl:text></xsl:if></xsl:template>


<!-- <xsl:if test="following-sibling::text() or not(substring(.,string-length(.)) = '&#10;')"><xsl:text>&#10;</xsl:text></xsl:if> -->

<!-- called from r:code/text()  so text() is the current node, not r:code -->
<xsl:template name="latexAttributes"><xsl:if test="./parent::*/@commentchar|./parent::*/@line|./parent::*/@formatcom|./parent::*/@fontfamily|./parent::*/@frame|./parent::*/@framerule|./parent::*/@label|./parent::*/@numbers|./parent::*/@framesep|./parent::*/@labelposition|./parent::*/@gobble">[<xsl:apply-templates select="./parent::*/@*" mode="latexAttribute"/>]</xsl:if></xsl:template>
<xsl:template match="@commentchar|@line|@formatcom|@fontfamily|@frame|@framerule|@label|@numbers|@framesep|@labelposition|@gobble" mode="latexAttribute"><xsl:value-of select="local-name(.)"/>=<xsl:value-of select="."/></xsl:template>


<xsl:template match="r:code[@lineNums='true']">\lstset{numbers=left}\begin{lstlisting}
<xsl:apply-templates/>
\end{lstlisting}<!--<xsl:if test="count(following-sibling::* | following-sibling::text()) > 0"><xsl:text>&#10;</xsl:text></xsl:if>--></xsl:template>

<!--  str:replace(string(.),'_','\_')  -->
<xsl:template match="r:code/text()"><xsl:call-template name="addErrorMarginParent"/>\begin{Rcode}<xsl:call-template name="latexAttributes"/><xsl:call-template name="trim-right"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template>
\end{Rcode}<xsl:if test="not(local-name(following-sibling::*[1]) = 'output')">
\vskip-10pt</xsl:if><!--<xsl:if test="count(following-sibling::* | following-sibling::text()) > 0"><xsl:text>&#10;</xsl:text></xsl:if>--></xsl:template>
<!-- <xsl:if test="following-sibling::text() or not(substring(.,string-length(.)) = '&#10;')"><xsl:text>&#10;</xsl:text></xsl:if> -->

<xsl:template name="addErrorMarginParent"><xsl:if test="../@error = 'true'"><xsl:message><xsl:value-of select="name()"/>adding @error</xsl:message>\marginnote{\includegraphics{MarginImages/no-symbol-hi_48.png}}[1.75\baselineskip]</xsl:if></xsl:template>

<xsl:template match="r:code[@xxx_error='true']/text()"><xsl:call-template name="addErrorMarginParent"/>\begin{Rcode}<xsl:call-template name="trim-right"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template>
\end{Rcode}<!--<xsl:if test="count(following-sibling::* | following-sibling::text()) > 0"><xsl:text>&#10;</xsl:text></xsl:if>--></xsl:template>

<!-- See latex/xsl.xsl in XDynDocs -->
<xsl:template match="xsl:code">\begin{XSLcode}
<xsl:apply-templates/>
\end{XSLcode}</xsl:template>
<xsl:template match="xsl:code/text()"><xsl:call-template name="trim-newlines"><xsl:with-param name="contents" select="string(.)"/></xsl:call-template></xsl:template>


<xsl:template match="r:code/text()[normalize-space(.) = '']"/>

<xsl:template match="ubi:attr">\UbiAttr{<xsl:apply-templates/>}</xsl:template>


<!-- Compute the name of the LaTeX color to use based on the name of the element, 
  e.g. sql:code maps to sqlcode, r:code maps to rcode.
  Really should use the URI and also should make the color names (e.g. sqlcode and shcolor) consistent. -->
<xsl:template name="getCodeColor"><xsl:value-of select="substring-before(name(.), ':')"/>code</xsl:template>

<xsl:template match="r:code[co] | programlisting[co] | sql:code[co] | r:function[highlight] | r:function[r:comment] | r:code[r:comment] | r:plot[r:comment] | c:code[c:comment] | c:function[c:comment]">{\color{<xsl:call-template name="getCodeColor"/>}
\begin{alltt}<xsl:apply-templates/>\end{alltt}
}
</xsl:template>
<!--\begin{Verbatim[commandchars=\\\{\}]<xsl:apply-templates/>\end{Verbatim}-->

<xsl:template match="r:code[co]/text() | programlisting[co]/text()">
<xsl:value-of select="."/>
</xsl:template>

<!--
<xsl:template match="r:function[highlight]">
\begin{Verbatim}[commandchars=\|\#\@]<xsl:apply-templates/>\end{Verbatim}
</xsl:template>
<xsl:template match="highlight">|textsl#|underline#<xsl:apply-templates/>@@</xsl:template>
-->
<xsl:template match="highlight">\textsl{{\color{red}\underline{<xsl:apply-templates/>}}}</xsl:template>
<xsl:template match="r:comment | c:comment">\textsl{{\color{red}<xsl:apply-templates/>}}</xsl:template>

<!-- In an alltt, the { } don't appear, so escape them for LaTeX -->
<!-- Was almost working: <xsl:template match="text()[parent::programlisting[@contentType = 'JSON'] or parent::programlisting[@escape] or ancestor::r:function[highlight] or ancestor::r:function[r:comment] or ancestor::r:code[r:comment] or ancestor::r:plot[r:comment] or ancestor::c:code[c:comment] or ancestor::c:function[c:comment]]"><xsl:value-of select="str:replace(str:replace(str:replace(str:replace(str:replace(string(.), '\n', '\textbackslash n'), '\r', '\textbackslash r'), '\\', '\textbackslash\textbackslash'), '{', '\{'), '}', '\}')"/></xsl:template> -->

<xsl:template match="text()[parent::programlisting[@contentType = 'JSON'] or parent::programlisting[@escape] or ancestor::r:function[highlight] or ancestor::r:function[r:comment] or ancestor::r:code[r:comment] or ancestor::r:plot[r:comment] or ancestor::c:code[c:comment] or ancestor::c:function[c:comment]]"><xsl:value-of select="str:replace(str:replace(str:replace(str:replace(str:replace(string(.), '{', '\{'), '}', '\}'), '\n', '\textbackslash{n}'), '\r', '\textbackslash{r}'), '\\', '\textbackslash\textbackslash')"/></xsl:template>

<!--
<xsl:template match="text()[(parent::highlight and ancestor::r:function)]"><xsl:message>r:function/highlight/text: <xsl:value-of select="."/></xsl:message><xsl:value-of select="str:replace(str:replace(string(.), '{', '\{'), '}', '\}')"/></xsl:template>
-->
<xsl:template match="highlight/text()"><xsl:value-of select="str:replace(str:replace(string(.), '{', '\{'), '}', '\}')"/></xsl:template>


<xsl:template match="programlisting[@escape]">{\color{<xsl:call-template name="getCodeColor"/>}
\begin{alltt}<xsl:apply-templates/>\end{alltt}
}
</xsl:template>
<xsl:template match="programlisting[@escape]/i">\textbf{\color{red}<xsl:apply-templates/>}</xsl:template>






<xsl:template match="book|article" mode="xx_lot">
  <xsl:param name="lot"/>
  <xsl:apply-imports mode="lot">
<!--    <xsl:with-param name="lot" select="$lot"/> -->
  </xsl:apply-imports>
</xsl:template>

<!--<xsl:template match="ulink[text()]">\url{<xsl:value-of select="."/>}</xsl:template>-->
<xsl:template match="ulink[@url and text()]">\href{<xsl:value-of select="@url"/>}{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="ulink[not(@url) and text()]">\url{<xsl:apply-templates/>}</xsl:template>

<!-- <xsl:template match="ulink | ulink[@url]"><xsl:apply-templates/></xsl:template>  -->
<!-- <xsl:template match="ulink[not(text())]">\url{<xsl:value-of select="@url"/>}</xsl:template> -->


<!--
<xsl:template match="xref[starts-with(@linkend, 'ex:')]">
<xsl:text>Q</xsl:text><xsl:message>q (starts-with) <xsl:value-of select="@linkend"/></xsl:message>
</xsl:template>
-->

<xsl:template match="xref[starts-with(@linkend, 'ex:') or starts-with(@linkend, 'eg:')]"><xsl:text>Q.</xsl:text>\ref{<xsl:value-of select="@linkend"/>}~(page~\pageref{<xsl:value-of select="@linkend"/>})</xsl:template>





<!-- Taken from dblatex. Have to change the order. -->
<xsl:template match="book|article">
  <xsl:param name="layout" select="$doc.layout"/>

  <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>
  <xsl:variable name="lang">
    <xsl:call-template name="l10n.language">
      <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
      <xsl:with-param name="xref-context" select="true()"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Latex preamble -->
  <xsl:apply-templates select="." mode="preamble">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:apply-templates>


  <xsl:value-of select="$latex.begindocument"/>

  <xsl:call-template name="lang.document.begin">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:call-template name="label.id"/>

  <xsl:if test="contains($layout, 'coverpage ')">
    <xsl:text>\maketitle&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="contains($layout, 'frontmatter ')">
    <xsl:value-of select="$frontmatter"/>
  </xsl:if>


  <!-- Print the abstract and front matter content -->
  <xsl:apply-templates select="dedication|preface|acknowledgements|contributors|editors"/>
  <xsl:apply-templates select="(abstract|$info/abstract)[1]"/>

  <!-- Print the TOC/LOTs -->
  <xsl:if test="contains($layout, 'toc ')">
    <xsl:apply-templates select="." mode="toc_lots"/>
  </xsl:if>

<!--  RESTORE IF WE GET THIS WORKING IN THIS LATEX STYLE
\clearpage%\newpage
\setlength{\cftExamplenumwidth}{2.35em}
\setlength{\cftExampleindent}{0pt}
-->

<!-- 
\listofExample  
\clearpage
 -->



  <!-- Body content -->
<xsl:if test="contains($layout, 'mainmatter ')">
%\input{acronyms}
<!-- <xsl:apply-templates select="//acronym[@id]" mode="define"/> -->
<xsl:value-of select="$mainmatter"/>
</xsl:if>
  <xsl:apply-templates select="*[not(self::abstract or
                                     self::preface or
                                     self::dedication or self::editors or
                                     self::colophon or self::contributors or self::acknowledgements)]"/>

  <!-- Back matter -->
  <xsl:if test="contains($layout, 'index ')">
    <xsl:call-template name="printindex"/>
  </xsl:if>
  <xsl:apply-templates select="colophon"/>
  <xsl:call-template name="lang.document.end">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:value-of select="$latex.enddocument"/>
</xsl:template>


<xsl:template match="code">\texttt{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="/book/title"/>
<xsl:template match="/book/title" mode="title"><xsl:apply-templates/></xsl:template>
<!--
<xsl:template name="printindex">
%\Extrachap{General Index}
%\clearpage
%\addcontentsline{toc}{chapter}{General Index}
\printindex*
</xsl:template>
-->

<!-- No ExtraChap or addcontentsline. These will produce duplicates.-->
<xsl:template name="printindex">
<xsl:if test="$multi.index">
\printindex[idx]
\printindex[Rfunc]
\printindex[Rpkg]
\printindex[Rclass]
</xsl:if>
<xsl:if test="not($multi.index)">
\printindex
</xsl:if>
</xsl:template>


<!-- Move this to springerLatex.xsl since it is specific unless Extrachap is part
 of a regular latex package. -->
<xsl:template match="bibliography">
<xsl:choose>
<xsl:when test="$bibliog.file = ''">
  <xsl:message>bibliography file not set (bibliog.file)</xsl:message>
</xsl:when>
<xsl:otherwise>
\clearpage

\chapter*{Bibliography}
\setcounter{tocdepth}{4}
\renewcommand{\bibsection}{}
\def\section*#1{\vskip-13em}
\bibliography{<xsl:value-of select="$bibliog.file"/>} 
\bibliographystyle{plain}
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="xrefs"><xsl:variable name="numXrefs" select="count(xref)"/><xsl:value-of select="@term"/>~<xsl:for-each select="xref">\ref{<xsl:value-of select="@linkend"/>}<xsl:if test="not(position() = last()) and $numXrefs > 2">, </xsl:if><xsl:if test="position() = last() - 1"> and </xsl:if></xsl:for-each></xsl:template>


<!-- See dblatex(-0.3)/xsl/sidebar.xsl -->
<xsl:template match="sidebar/title">\message{SIDEBAR: <xsl:value-of select="string(.)"/>^^J}
  <xsl:text>\textbf{</xsl:text>
<xsl:apply-templates/>
<xsl:text>}&#10;&#10;\nopagebreak &#10;</xsl:text>
</xsl:template>

<xsl:template match="rest">\acronym{REST}</xsl:template>

<xsl:template match="table//entry//br">\hfill\break </xsl:template>


<!-- 
Ignore for now as we finish the book manually.
This is for removing the white space blank line after the \begin{sloppy} and before the text
that is caused by <para>
The start of the text.

<xsl:template match="para[@sloppy and starts-with(string(.), '&#10;')]"><xsl:message>got one</xsl:message>
\begin{sloppy}<xsl:apply-templates/>\end{sloppy}</xsl:template>
 -->


<xsl:template match="b">\textbf{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="finish">
<xsl:message>**** Finish this paragraph (some file, line <xsl:value-of select="saxon:line-number()"/>, <xsl:value-of select="saxon:systemId()"/>)</xsl:message>
</xsl:template>

<xsl:template match="part/article">
<xsl:message>part/article <xsl:value-of select="../@id"/></xsl:message>
<xsl:apply-templates/>
</xsl:template>

<!--
<xsl:template match="part/chapter/authorgroup">
\chapter*{<xsl:apply-templates select="title"/>}
</xsl:template>
-->

<xsl:template match="author" mode="authorChap">
\chapterauthor{<xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:if test="othername[@role='mi']"><xsl:value-of select="othername[@role='mi']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="surname"/>}{<xsl:value-of select="affiliation/orgname"/>}</xsl:template>

<xsl:template match="chapter">
<xsl:apply-templates select="author|authorgroup/author|articleinfo/authorgroup/author" mode="authorChap"/>
\chapter{<xsl:apply-templates select="title | articleinfo/title"/>}<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}\hyperlabel{<xsl:value-of select="@id"/>}</xsl:if> <!-- XXX put @id as a label for xrefs -->

\begin{bibunit}

<xsl:apply-templates select="text() | *[not(self::authorgroup or self::author or self::title)]"/>


\putbib

\end{bibunit}
</xsl:template>


<xsl:template match="keywords">
\textbf{\large{Keywords}}: <xsl:apply-templates/>
<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="keyword">
<xsl:apply-templates/><xsl:if test="not(position() = last())">, </xsl:if><xsl:if test="position() = last()">.</xsl:if>
</xsl:template>

<!-- %\setcounter{ExerciseCounter}{10} -->
<xsl:template match="chapter/title | articleinfo/title">
<xsl:apply-templates/>
</xsl:template>


<!--
These 2 worked but want to use \chapterauthor before chapter.
<xsl:template match="chapter">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="chapter/title | article/articleinfo/title">
<xsl:message>chapter/title</xsl:message>
\chapter{<xsl:apply-templates />}
</xsl:template>
-->

<xsl:template match="authorgroup">
<xsl:for-each select=".//author"><xsl:apply-templates select="."/><xsl:if test="not(position() = last())">\\
</xsl:if></xsl:for-each>


<!-- Leave space after the authors. -->
</xsl:template>


<xsl:template match="part/article/articleinfo/title">
\chapter{<xsl:apply-templates/>}
</xsl:template>

<!--
<xsl:template match="part/article//section[not(ancestor::section)]/title">
\section*{<xsl:apply-templates/>}
</xsl:template>
-->

<!--
<xsl:template match="article//section/title">
\section{<xsl:apply-templates/>}
</xsl:template>
-->

<xsl:template match="filename">\nolinkurl{<xsl:value-of select="str:replace(str:replace(., '_', '\_'),'~', '\(\sim \)')"/>}</xsl:template>

<xsl:template match="person"><xsl:apply-templates/></xsl:template> <!-- in acknowledgements -->

<xsl:template match="acknowledgements">
\chapter*{Acknowledgments}
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="editors">
\chapter*{Authors}

<xsl:apply-templates/>
</xsl:template>



<xsl:template match="alternative">
\begin{Alternative}
<xsl:apply-templates/>
\end{Alternative}
</xsl:template>

<xsl:template match="alternative">
\marginnote{\vskip10pt{\small Alternative Approach}}
\begin{CropFrame}[1cm][2pt][0.6cm][black][4][0ex]
<xsl:apply-templates/>
\end{CropFrame}
</xsl:template>

<xsl:template match="answer"/>


<xsl:template match="author[ancestor::bookinfo]">
<xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:if test="othername[@role='mi']"><xsl:value-of select="othername[@role='mi']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="surname"/>, <xsl:value-of select="affiliation/orgname"/>
</xsl:template>


<!-- If we have two people with the same surname, we have to do more! Just concat firstname and surname.  -->
<xsl:key name="contributors" match="author" use="string(surname)"/>
<xsl:variable name="authors" select="//author[not(ancestor::ignore) and not(ancestor::biblioentry) and not(firstname = 'Deborah') and not(firstname = 'Duncan')]"/>


<!-- See http://blog.beacontechnologies.com/grouping-in-xslt-using-the-muenchian-method/ -->
<xsl:template match="contributors">
\chapter*{Co-Authors}

\begin{multicols}{2} % (parent::authorgroup or parent::article or parent::chapter)
<xsl:for-each select="$authors[count(. | key('contributors', string(surname))[1]) = 1]">
   <xsl:sort select="surname"/>
   <xsl:variable name="sur" select="string(surname)"/>
<!--   <xsl:message>groupKey <xsl:value-of select="$sur"/>  <xsl:value-of select="string(.)"/> </xsl:message> -->
   <xsl:apply-templates select="." mode="contributor"/>
</xsl:for-each>

<!-- <xsl:apply-templates select="//author[not(ancestor::ignore) and not(ancestor::biblioentry)]" mode="contributor"/> -->

\end{multicols}

</xsl:template>

<!-- Need unique authors, not set of all authors. And may want to restrict to article/chapter -->
<xsl:template match="author" mode="contributor">

\contributor{<xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:if test="othername[@role='mi']"><xsl:value-of select="othername[@role='mi']"/><xsl:text> </xsl:text></xsl:if><xsl:value-of select="surname"/>}{<xsl:value-of select="affiliation/orgname"/>}{<xsl:value-of select="affiliation/address/city"/>, <xsl:value-of select="affiliation/address/state"/>, <xsl:value-of select="affiliation/address/country"/>}

<xsl:if test="@break">\columnbreak</xsl:if>
</xsl:template>


<xsl:template match="question">
Question: <xsl:apply-templates/>
</xsl:template>

<xsl:template match="answer">

\noindent
Answer: <xsl:apply-templates/>
</xsl:template>

<!-- Don't use the one in dblatex. -->
<xsl:template match="prompt">\PVerb{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="note[question/answer] | box">

\vskip.1in
\begin{mdframed}[style=QASidebar<xsl:if test="@nopagebreak">,nobreak=true</xsl:if>]<xsl:apply-templates />\end{mdframed}
\vskip10pt
</xsl:template>


<!-- Was: <xsl:template match="ulink[@url and string(.) = '']">\nolinkurl{<xsl:value-of select="str:replace(str:replace(@url, '_', '\_'), '#', '\#')"/>}</xsl:template> 
-->
<xsl:template match="ulink[@url and string(.) = '']">\url{<xsl:value-of select="str:replace(str:replace(@url, '_', '\_'), '#', '\#')"/>}</xsl:template>



<xsl:template match="center">\begin{center}
<xsl:apply-templates/>
\end{center}
</xsl:template>


<xsl:template match="exercise[count(q) = 100000]">

\begin{exercisePar}
\noindent\textbf{Exercise} <xsl:apply-templates/>
\end{exercisePar}

</xsl:template>

<xsl:template match="exercise">
<xsl:if test="false and not(parent::section[string(./title) = 'Exercises'])">\subsection*{Exercise<xsl:if test="count(q) > 1">s</xsl:if>}
</xsl:if>
<xsl:if test="count(q) > 0">
\begin{enumerate}</xsl:if>
<xsl:apply-templates/>
<xsl:if test="not(name((following-sibling::*)[1]) = 'section') and count(following-sibling::*) > 0">

\nopagebreak\noindent\hfil\rule{0.5\textwidth}{.1pt}\hfil\vskip10pt
</xsl:if>
<xsl:if test="count(q) > 0">
\end{enumerate}</xsl:if>
</xsl:template>


<!-- <xsl:if test="count(../q) > 0">\item[\textbf{Q.\theExerciseCounter}] </xsl:if> -->
<xsl:template match="q">
 
  \refstepcounter{ExerciseCounter}<xsl:if test="not(preceding-sibling::q)">\marginnote{\nopagebreak\includegraphics{MarginImages/questionMark_48.png}}</xsl:if>  
Q. \theExerciseCounter{} <xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if><xsl:apply-templates/>
</xsl:template>

<xsl:template match="q/text()"><xsl:value-of select="normalize-space(.)"/></xsl:template>

<!-- Kill off the answers. Leave them for the question/answer Michael uses in his chapter -->
<xsl:template match="q/answer"/>


<!-- 
 Not used anymore.

<xsl:template match="chapter[@nonumber = 'true']">
\chapter*{<xsl:value-of select="@title"/>}
<xsl:apply-templates/>
</xsl:template>
 -->

<xsl:template match="marginDbend">
\marginnote{\dbend}
</xsl:template>


<xsl:template match="llvm">\llvm{}</xsl:template>
<xsl:template match="fortran">\FORTRAN</xsl:template>
<xsl:template match="nimble">\texttt{NIMBLE}</xsl:template>

<xsl:template match="lldb">\lldb</xsl:template>

<xsl:template match="julia">\Julia</xsl:template>
<xsl:template match="cxxr">\CXXR</xsl:template>
<xsl:template match="fastr">\FastR</xsl:template>
<xsl:template match="lisp">\LISP</xsl:template>

<xsl:template match="lucene">\Lucene{}</xsl:template>
<xsl:template match="hadoop">\Hadoop{}</xsl:template>

<xsl:template match="dsl">\textit{DSL}</xsl:template>
<xsl:template match="ir">\textsl{IR}</xsl:template>

<!-- Need the new line after the marginnote -->
<xsl:template match="fix">\marginnote{{\color{RED}FIX}}</xsl:template>


<xsl:template match="table[ancestor::figure]">\begin{tabular}{<xsl:value-of select="@ltx:format"/>}<xsl:apply-templates/>\end{tabular}</xsl:template>

<xsl:template match="table/tgroup[ancestor::figure] | table//tbody[ancestor::figure]">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="rx|regex|regexpr">\verb@<xsl:apply-templates/>@</xsl:template>

<xsl:template match="dtl|deb"/>


<xsl:template match="orderedlist[formalpara]">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="listitem[parent::formalpara and local-name(../..) = 'orderedlist']">

\refstepcounter{ExerciseCounter}
\noindent \textbf{Q.\theExerciseCounter}{}  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="ndash">–</xsl:template>
<xsl:template match="mdash">---</xsl:template>


<xsl:template match="html[not(ancestor::caption)]|HTML">\MarkupLang{HTML}\index{HTML@\MarkupLang{HTML}}</xsl:template>
<xsl:template match="xml[not(ancestor::caption)]|XML">\MarkupLang{XML}\index{XML@\MarkupLang{XML}}</xsl:template>

<xsl:template match="exercise/formalpara">

\par\vskip\baselineskip\vbox{\parbox[t]{\linewidth}{\textbf{<xsl:value-of select="title"/>}}}

</xsl:template>
<!-- \noindent\textbf{<xsl:value-of select="title"/>} -->


<xsl:template match="so|SO">\SO\index{StackOverflow}</xsl:template>
<xsl:template match="autoconf">\Autoconf\index{A@Autoconf}</xsl:template>
<xsl:template match="cmake">\CMake\index{C@CMake}</xsl:template>
<xsl:template match="make">\Make\index{M@Make}</xsl:template>

<xsl:template match="google">\Google</xsl:template>
<xsl:template match="facebook">\Facebook</xsl:template>
<xsl:template match="amazon">\Amazon</xsl:template>
<xsl:template match="ms|microsoft">Microsoft</xsl:template>

<xsl:template match="github">github\index{G@github}</xsl:template>
<xsl:template match="git">\textsl{git}\index{G@git}</xsl:template>
<xsl:template match="git:*">\textbf{<xsl:value-of select='local-name()'/>}\index{<xsl:value-of select='local-name()'/>}</xsl:template>

<xsl:template match="bq|bigquery">\BigQuery</xsl:template>

<xsl:template match="sqlite:cmd">\SQLiteCmd{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="sqlite:param">\SQLiteParam{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="py:mod">\PyModule{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="lldb:cmd">\LLDBCmd{<xsl:apply-templates/>}</xsl:template>


<!-- From XDynDocs/inst/XSL/OmegahatXSL/latex/sql.xsl -->
<xsl:template match="lldb:code">
<xsl:if test="$use.code.marginnote.identifiers">\begin{LLDBCodePar}[<xsl:value-of select="(string-length() - string-length(translate(., '&#xA;', '')) - 1) div 2"/>]
</xsl:if>
<xsl:call-template name="makeCodeEnv"><xsl:with-param name="codeName">LLDBCode</xsl:with-param></xsl:call-template>
<xsl:if test="$use.code.marginnote.identifiers">
\end{LLDBCodePar}</xsl:if>
</xsl:template>

<xsl:template match="note" mode="xref-to">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Note'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="label.markup"/>  
</xsl:template>

<xsl:template match="note" mode="label.markup" priority="1">
  <xsl:text>\ref{</xsl:text>
  <xsl:value-of select="(@id|@xml:id)[1]"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="r:class[. = '{'] | literal[. = '{']">$\lbrace$
</xsl:template>

<xsl:template match="moved"/>

<!-- <xsl:template match="/book/title">\title{<xsl:apply-templates/>}</xsl:template> -->
<xsl:template match="/book/title"><xsl:apply-templates/>
</xsl:template>

<xsl:template match="chapter/abstract">
\begin{quote}  
  <xsl:apply-templates/>
\end{quote}  
</xsl:template>

<xsl:template match="acronym">\gls{<xsl:apply-templates/>}\index{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="acronym[@id]">\gls{<xsl:value-of select="@id"/>}\index{<xsl:value-of select="translate(@id, 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>}</xsl:template>
<!--
<xsl:template match="acronym" mode="define">\newacronym{<xsl:value-of select="@id"/>}{<xsl:apply-templates/>}{<xsl:value-of select="@defn"/>}
</xsl:template>
-->

</xsl:stylesheet>

