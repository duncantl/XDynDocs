<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:r="http://www.r-project.org"
	xmlns:omg="http://www.omegahat.org"
	xmlns:bioc="http://www.bioconductor.org"
        version="1.0">


<xsl:template match="r:package|r:pkg|rpkg">\pkg{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="omg:pkg">\OmgPackage{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="bioc:pkg">\BioCPackage{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="r|R">\proglang{R}</xsl:template>
<xsl:template match="latex[string(.) = '']">\LaTeX{}</xsl:template>

<xsl:template match="html|HTML">\proglang{HTML}</xsl:template>
<xsl:template match="js">\proglang{JavaScript}\index{JavaScript}@\proglang{JavaScript}</xsl:template>
<xsl:template match="js[ancestor::title or ancestor::summary]">\proglang{JavaScript}</xsl:template>
<xsl:template match="xpath">\proglang{XPath}\index{XPath@\proglang{XPath}}</xsl:template>
<xsl:template match="xpath[ancestor::title or ancestor::summary]">\proglang{XPath}</xsl:template>
<xsl:template match="xml">\proglang{XML}\index{XML}@\proglang{XML}</xsl:template>
<xsl:template match="xml[ancestor::title or ancestor::summary]">\proglang{XML}</xsl:template>
<xsl:template match="C">\proglang{C}\index{C@\proglang{C}}</xsl:template>
<xsl:template match="C[ancestor::title or ancestor::summary]">\proglang{C}</xsl:template>

<xsl:template match="proglang">\proglang{<xsl:apply-templates/>}\index{<xsl:apply-templates/>@\proglang{<xsl:apply-templates/>}}</xsl:template>
<xsl:template match="proglang[ancestor::title or ancestor::summary]">\proglang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="mklang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="markupLang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="svg">\MarkupLang{SVG}\index{SVG@\MarkupLang{SVG}}</xsl:template>
<xsl:template match="svg[ancestor::title or ancestor::summary]">\MarkupLang{SVG}</xsl:template>
<xsl:template match="kml">\MarkupLang{KML}\index{KML@\MarkupLang{KML}}</xsl:template>
<xsl:template match="kml[ancestor::title or ancestor::summary]">\MarkupLang{KML}</xsl:template>
<xsl:template match="gml">\MarkupLang{GML}\index{GML@\MarkupLang{GML}}</xsl:template>
<xsl:template match="gml[ancestor::title or ancestor::summary]">\MarkupLang{GML}</xsl:template>



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

<xsl:template match="wsdl">\WSDL\index{WSDL@\WSDL}</xsl:template>
<xsl:template match="wsdl[ancestor::title or ancestor::summary]">\WSDL</xsl:template>

<xsl:template match="wadl">\WADL\index{WADL@\WADL}</xsl:template>
<xsl:template match="wadl[ancestor::title or ancestor::summary]">\WADL</xsl:template>
<xsl:template match="oauth">\OAuth\index{OAuth@\OAuth}</xsl:template>
<xsl:template match="oauth[ancestor::title or ancestor::summary]">\OAuth</xsl:template>
<xsl:template match="oauth2">\OAuthTwo\index{OAuth2@\OAuthTwo}</xsl:template>
<xsl:template match="oauth2[ancestor::title or ancestor::summary]">\OAuthTwo</xsl:template>
<xsl:template match="ssl">\SSL\index{SSL@\SSL}</xsl:template>
<xsl:template match="ssl[ancestor::title or ancestor::summary]">\SSL</xsl:template>

<xsl:template match="dsl">DSL\index{DSL}</xsl:template>
<xsl:template match="uri|URI">URI\index{URI}</xsl:template>
<xsl:template match="dcom|DCOM">\DCOM\index{DCOM@\DCOM}</xsl:template>
<xsl:template match="sweave">\Sweave\index{Sweave@\Sweave}</xsl:template>
<xsl:template match="knitr">\knitr\index{knitr@\knitr}</xsl:template>
<xsl:template match="pandoc">\pandoc\index{pandoc@\pandoc}</xsl:template>

<xsl:template match="dll|dso|lib">\DLL{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="dso">\DSO{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="proj">\Project{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="directory|dir">\texttt{<xsl:apply-templates/>/}</xsl:template>
<xsl:template match="markupLang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="s4">\acronym{S4}</xsl:template>
<xsl:template match="s3">\acronym{S3}</xsl:template>
<xsl:template match="r:s3class">\S3class{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="soap">\acronym{SOAP}\index{SOAP}</xsl:template>
<xsl:template match="pdf">\acronym{PDF}\index{PDF}</xsl:template>
<xsl:template match="html5">\acronym{HTML5}\index{HTML5}</xsl:template>
<xsl:template match="xhtml">\acronym{XHTML}\index{XHTML}</xsl:template>

<xsl:template match="dblatex">\textit{dblatex}</xsl:template>

<xsl:template match="libcurl">\DLL{curl}\index{libcurl@\DLL{curl}}</xsl:template>
<xsl:template match="libxml|libxml2">\DLL{xml2}\index{libxml2@\DLL{xml2}}</xsl:template>
<xsl:template match="libxslt">\DLL{libxslt}</xsl:template>


<xsl:template match="nosql">\NoSQL\index{NoSQL@\NoSQL}</xsl:template>
<xsl:template match="nosql[ancestor::title or ancestor::summary]">\NoSQL</xsl:template>
<xsl:template match="ext">\FileExt{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="zip">\FileExt{zip}</xsl:template>
<xsl:template match="xlsx">\FileExt{xlsx}</xsl:template>
<xsl:template match="gzip">\FileExt{gz}</xsl:template>

<xsl:template match="CSV|csv">CSV\index{CSV}</xsl:template>
<xsl:template match="tsv">TSV\index{TSV}</xsl:template>
<xsl:template match="bz2">\FileExt{bz2}</xsl:template>

<xsl:template match="png">\PNG\index{PNG@\PNG}</xsl:template>

<xsl:template match="opengl">\proglang{opengl}</xsl:template>

<xsl:template match="gcc">\ShApp{GCC}</xsl:template>

</xsl:stylesheet>