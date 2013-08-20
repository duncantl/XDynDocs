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
<xsl:template match="js">\proglang{JavaScript}</xsl:template>
<xsl:template match="xpath">\proglang{XPath}</xsl:template>
<xsl:template match="xml">\proglang{XML}</xsl:template>
<xsl:template match="C">\proglang{C}</xsl:template>

<xsl:template match="proglang">\proglang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="mklang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="markupLang">\MarkupLang{<xsl:apply-templates/>}</xsl:template>
<xsl:template match="svg">\MarkupLang{SVG}</xsl:template>
<xsl:template match="kml">\MarkupLang{KML}</xsl:template>
<xsl:template match="gml">\MarkupLang{GML}</xsl:template>



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
<xsl:template match="wadl">\WADL\index{WADL@\WADL}</xsl:template>
<xsl:template match="oauth">\OAuth\index{OAuth@\OAuth}</xsl:template>
<xsl:template match="oauth2">\OAuthTwo\index{OAuth2@\OAuthTwo}</xsl:template>
<xsl:template match="ssl">\SSL\index{SSL@\SSL}</xsl:template>
<xsl:template match="dsl">DSL\index{DSL}</xsl:template>
<xsl:template match="uri|URI">URI\index{URI}</xsl:template>
<xsl:template match="dcom|DCOM">\DCOM\index{DCOM@\DCOM}</xsl:template>
<xsl:template match="sweave">\Sweave\index{Sweave@\Sweave}</xsl:template>
<xsl:template match="knitr">\knitr\index{knitr@\knitr}</xsl:template>
<xsl:template match="pandoc">\pandoc\index{pandoc@\pandoc}</xsl:template>


</xsl:stylesheet>