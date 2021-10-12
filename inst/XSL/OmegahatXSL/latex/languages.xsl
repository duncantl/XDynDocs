<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:r="http://www.r-project.org"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
	xmlns:gh="http://github.com"
        version="1.0">


<!-- Should be in languages.xsl but problems there as that is multiply included 
     and if we avoid that, then the *:pkg templates are not found. 
     Need the include languages.xsl in latex.xsl 
  Now in languages.xsl again.  latex.xsl is the only file that includes this.
  latex.xsl is included by basicLatex.xsl and also biblio.xsl  -->
<xsl:template name="addIndexEntryString">
  <!--  or ancestor::functionSummaryTable  -->
<xsl:if test="ancestor::table or ancestor::title or ancestor::caption or ancestor::summary">\string</xsl:if>
</xsl:template>

<xsl:template match="r:package|r:pkg|rpkg">\pkg{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="omg:pkg">\OmgPackage{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="bioc:pkg">\BioCPackage{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="r|R">\proglang{R}</xsl:template>
<!--<xsl:template match="proglang[. = 'R']">\proglang{R}</xsl:template>-->

<xsl:template match="docbook">\MarkupLang{DocBook}<xsl:if test="not(ancestor::title) and not(ancestor::summary) and not(ancestor::caption)">\index{DocBook@\MarkupLang{DocBook}}</xsl:if></xsl:template>
<xsl:template match="rdocbook">\MarkupLang{RDocBook}\index{RDocBook@\MarkupLang{RDocBook}}</xsl:template>

<xsl:template match="latex[string(.) = '']">\LaTeX{}\index{LaTeX@\LaTeX}</xsl:template>
<!--<xsl:template match="latex[string(.) = '']">\LaTeX{}</xsl:template>-->

<xsl:template match="html|HTML">\proglang{HTML}</xsl:template>
<xsl:template match="js|javascript">\proglang{JavaScript}\index{JavaScript@\proglang{JavaScript}}</xsl:template>
<xsl:template match="wasm|WASM">\proglang{WASM}\index{WASM@\proglang{WASM}}</xsl:template>
<xsl:template match="js[ancestor::title or ancestor::summary]">\proglang{JavaScript}</xsl:template>
<xsl:template match="xpath">\proglang{XPath}\index{XPath@\proglang{XPath}}</xsl:template>
<xsl:template match="xpath[ancestor::title or ancestor::summary]">\proglang{XPath}</xsl:template>
<!--<xsl:template match="xml">\proglang{XML}\index{XML}@\proglang{XML}</xsl:template>-->
<xsl:template match="xml">\proglang{XML}</xsl:template>
<xsl:template match="xml[ancestor::title or ancestor::summary]">\proglang{XML}</xsl:template>
<xsl:template match="c|C">\proglang{C}\index{C@\proglang{C}}</xsl:template>
<xsl:template match="C[ancestor::title or ancestor::summary]">\proglang{C}</xsl:template>
<xsl:template match="objc">\proglang{Objective-C}\index{Objective-C@\proglang{Objective-C}}</xsl:template>
<xsl:template match="go">\proglang{Go}\index{GoObjective-C@\proglang{Go}}</xsl:template>


<xsl:template match="api">API\index{API}</xsl:template>


<xsl:template match="css">\proglang{CSS}<xsl:if test="not(ancestor::biblioentry)">\index{CSS@<xsl:call-template name="addIndexEntryString"/>\CSS}</xsl:if></xsl:template>
<!-- ancestor::caption     No need for formalpara. -->
<xsl:template match="css[ancestor::caption and ancestor::figure and not(ancestor::example)]">\proglang{CSS}\index{CSS@\string\CSS}</xsl:template>
<xsl:template match="css[ancestor::summary or ancestor::example]">\proglang{CSS}</xsl:template>
<xsl:template match="css[ancestor::footnote]" priority="100"><xsl:message>CSS index for footnote</xsl:message>\proglang{CSS}\index{CSS@\string\CSS}</xsl:template>

<xsl:template match="proglang">\proglang{<xsl:apply-templates/>}\index{<xsl:apply-templates/>@\proglang{<xsl:apply-templates/>}}</xsl:template>
<xsl:template match="proglang[acronym]">\proglang{<xsl:apply-templates/>}\index{<xsl:value-of select="acronym/text()"/>@\proglang{<xsl:apply-templates/>}}</xsl:template>


<xsl:template match="proglang[string(.) = 'R' or string(.) = 'XML']">\proglang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="proglang[ancestor::title or ancestor::summary]">\proglang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="mklang">\MarkupLang{<xsl:apply-templates/>}\index{<xsl:value-of select="."/>}</xsl:template>
<xsl:template match="markupLang">\MarkupLang{<xsl:apply-templates/>}\index{<xsl:value-of select="."/>}</xsl:template>
<xsl:template match="s|S">\MarkupLang{S}\index{S}</xsl:template>
<xsl:template match="splus|s-plus">\MarkupLang{S-Plus}\index{S-Plus}</xsl:template>
<!--<xsl:template match="markupLang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>-->

<xsl:template match="xsl">\MarkupLang{XSL}\index{XSL@\MarkupLang{XSL}}</xsl:template>

<xsl:template match="svg">\MarkupLang{SVG}\index{SVG@\MarkupLang{SVG}}</xsl:template>
<xsl:template match="svg[ancestor::title or ancestor::summary]">\MarkupLang{SVG}</xsl:template>
<xsl:template match="kml">\MarkupLang{KML}\index{KML@\MarkupLang{KML}}</xsl:template>
<xsl:template match="kml[ancestor::title or ancestor::summary]">\MarkupLang{KML}</xsl:template>
<xsl:template match="gml">\MarkupLang{GML}\index{GML@\MarkupLang{GML}}</xsl:template>
<xsl:template match="gml[ancestor::title or ancestor::summary]">\MarkupLang{GML}</xsl:template>


<xsl:template match="amazonS3">Amazon S3\index{Amazon!S3@S3}</xsl:template>


<xsl:template match="DTD|dtd">\proglang{DTD}\index{DTD}</xsl:template>
<xsl:template match="xmlrpc">XML-RPC\index{XML-RPC}</xsl:template>
<xsl:template match="cran">CRAN\index{CRAN}</xsl:template>
<xsl:template match="es">\acronym{ElasticSearch}\index{ElasticSearch}</xsl:template>
<xsl:template match="xlink">\proglang{XLink}\index{XLink@\proglang{XLink}}</xsl:template>
<xsl:template match="xinclude">\proglang{XInclude}\index{XInclude@\proglang{XInclude}}</xsl:template>
<xsl:template match="xquery">\proglang{XQuery}\index{XQuery@\proglang{XQuery}}</xsl:template>
<xsl:template match="xpointer">\proglang{XPointer}\index{XPointer@\proglang{XPointer}}</xsl:template>
<xsl:template match="xpath|proglang[. = 'XPath']">\proglang{XPath}\index{XPath@\proglang{XPath}}</xsl:template>
<xsl:template match="ruby">\proglang{Ruby}\index{Ruby@\proglang{Ruby}}</xsl:template>
<xsl:template match="omegahat">Omegahat</xsl:template>
<xsl:template match="unix|UNIX">\acronym{UNIX}\index{UNIX}</xsl:template>
<xsl:template match="linux|Linux">\acronym{Linux}\index{Linux}</xsl:template>
<xsl:template match="gnu">\acronym{GNU}\index{GNU}</xsl:template>
<xsl:template match="osx">\acronym{OSX}\index{OSX}</xsl:template>
<xsl:template match="windows">\textsl{Microsoft Windows}\index{Microsoft Windows}</xsl:template>

<xsl:template match="wsdl">\WSDL\index{WSDL@<xsl:call-template name="addIndexEntryString"/>\WSDL}</xsl:template>
<!--<xsl:template match="wsdl[ancestor::title or ancestor::summary]">\WSDL</xsl:template>-->

<xsl:template match="wadl">\WADL\index{WADL@<xsl:call-template name="addIndexEntryString"/>\WADL}</xsl:template>
<!--<xsl:template match="wadl[ancestor::title or ancestor::summary]">\WADL</xsl:template>-->
<xsl:template match="oauth">\OAuth\index{OAuth@<xsl:call-template name="addIndexEntryString"/>\OAuth}</xsl:template>
<!--<xsl:template match="oauth[ancestor::title or ancestor::summary]">\OAuth</xsl:template>-->
<xsl:template match="oauth2">\OAuthTwo\index{OAuth2@<xsl:call-template name="addIndexEntryString"/>\OAuthTwo}</xsl:template>
<!--<xsl:template match="oauth2[ancestor::title or ancestor::summary]">\OAuthTwo</xsl:template>-->
<xsl:template match="ssl">\SSL\index{SSL@<xsl:call-template name="addIndexEntryString"/>\SSL}</xsl:template>
<!-- <xsl:template match="ssl[ancestor::title or ancestor::summary]">\SSL</xsl:template> -->

<xsl:template match="dsl">DSL\index{DSL}</xsl:template>
<xsl:template match="uri|URI">URI\index{URI}</xsl:template>
<xsl:template match="dcom|DCOM">\DCOM\index{DCOM@\DCOM}</xsl:template>
<xsl:template match="sweave">\Sweave\index{Sweave@\Sweave}</xsl:template>
<xsl:template match="knitr">\knitr\index{knitr@\knitr}</xsl:template>
<xsl:template match="pandoc">\pandoc\index{pandoc@\pandoc}</xsl:template>

<xsl:template match="dll[text()]|dso[text()]|lib[text()]">\DllWord{}</xsl:template>

<xsl:template match="dll|dso|lib">\DLL{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="dso">\DSO{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="proj">\Project{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="directory|dir">\texttt{<xsl:apply-templates/>/}</xsl:template>


<xsl:template match="gh:repos[@url]">\GithubRepos2{<xsl:apply-templates/>}{<xsl:apply-templates select="@url"/>}</xsl:template>
<xsl:template match="gh:repos">\GithubRepos{<xsl:apply-templates/>}</xsl:template>


<xsl:template match="github">\Github{}</xsl:template>


<xsl:template match="s4">\acronym{S4}\index{S4}</xsl:template>
<xsl:template match="s3">\acronym{S3}\index{S3}</xsl:template>
<xsl:template match="r5">\textsl{Reference/R5 classes}\index{Reference classes}</xsl:template>
<xsl:template match="r:s3class">\S3class{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="soap">\acronym{SOAP}\index{SOAP}</xsl:template>
<xsl:template match="pdf">\acronym{PDF}\index{PDF}</xsl:template>
<xsl:template match="html5">\proglang{HTML5}\index{HTML5@<xsl:call-template name="addIndexEntryString"/>\proglang{HTML5}}</xsl:template>
<xsl:template match="xhtml">\proglang{XHTML}\index{XHTML@<xsl:call-template name="addIndexEntryString"/>\proglang{XHTML}}</xsl:template>

<xsl:template match="dblatex">\textit{dblatex}</xsl:template>

<xsl:template match="libcurl">\DLL{curl}\index{libcurl@\DLL{curl}}</xsl:template>
<xsl:template match="libxml|libxml2">\DLL{xml2}\index{libxml2@\DLL{xml2}}</xsl:template>
<xsl:template match="libxslt">\DLL{libxslt}</xsl:template>

<xsl:template match="solr">\Solr\index{Solr@\Solr}</xsl:template>
<xsl:template match="nosql">\NoSQL\index{NoSQL@\NoSQL}</xsl:template>
<xsl:template match="nosql[ancestor::title or ancestor::summary]">\NoSQL</xsl:template>
<xsl:template match="ext">\FileExt{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="zip">\FileExt{zip}</xsl:template>
<xsl:template match="xlsx">\FileExt{xlsx}</xsl:template>
<xsl:template match="gzip">\FileExt{gz}</xsl:template>

<xsl:template match="CSV|csv">\FileExt{CSV}\index{CSV}</xsl:template>
<xsl:template match="tsv">\FileExt{TSV}\index{TSV}</xsl:template>
<xsl:template match="bz2">\FileExt{bz2}</xsl:template>

<xsl:template match="rds">\FileExt{Rds}\index{Rds}</xsl:template>
<xsl:template match="rda">\FileExt{Rda}\index{Rda}</xsl:template>

<xsl:template match="tiff">\Tiff\index{Tiff@\Tiff}</xsl:template>
<xsl:template match="png">\PNG\index{PNG@\PNG}</xsl:template>
<xsl:template match="jpeg|jpg">\JPEG\index{JPEG@\JPEG}</xsl:template>

<xsl:template match="opengl">\proglang{OpenGL}</xsl:template>

<xsl:template match="gcc">\ShApp{GCC}</xsl:template>


<xsl:template match="spark">\proglang{Spark}\index{Spark@<xsl:call-template name="addIndexEntryString"/>\proglang{Spark}}</xsl:template>

<!-- Were in springerLatex.xsl -->
<xsl:template match="sfc">\textit{San Francisco Chronicle}</xsl:template>
<xsl:template match="nyt">\textit{New York Times}\index{New\ York\ Times@\textit{New York Times}}</xsl:template>
<xsl:template match="jss">\textit{Journal of Statistical Software}</xsl:template>

<xsl:template match="rest">\acronym{REST}</xsl:template>

</xsl:stylesheet>
