<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version='1.0'
	 xmlns:xi="http://www.w3.org/2003/XInclude">

<xsl:template match="docbook">DocBook</xsl:template>
<xsl:template match="perl"><proglang>PERL</proglang></xsl:template>
<xsl:template match="r|R"><proglang>R</proglang></xsl:template>

<xsl:template match="js"><proglang>JavaScript</proglang></xsl:template>
<xsl:template match="xml"><proglang><acronym def="eXtensible Markup Language">XML</acronym></proglang></xsl:template>
<xsl:template match="sgml"><proglang><acronym def="Structured Generalized Markup Language">SGML</acronym></proglang></xsl:template>
<xsl:template match="svg"><proglang>SVG</proglang></xsl:template>
<xsl:template match="xsl"><proglang><acronym def="eXtensible Stylesheet Language">XSL</acronym></proglang></xsl:template>
<xsl:template match="xslt"><proglang><acronym def="eXtensible Stylesheet Language Transformer">XSLT</acronym></proglang></xsl:template>

<xsl:template match="perl"><proglang>PERL</proglang></xsl:template>
<xsl:template match="ruby"><proglang>Ruby</proglang></xsl:template>
<xsl:template match="word">Microsoft Word</xsl:template>
<xsl:template match="css"><proglang><acronym def="CSS">CSS</acronym></proglang></xsl:template>


<xsl:template match="fo"><proglang>FO</proglang></xsl:template>

<!-- Should this <format><acronym>..   or <acronym><format> -->
<xsl:template match="JSON|json"><acronym def="JavaScript Object Notation"><markupLang>JSON</markupLang></acronym></xsl:template>
<xsl:template match="xpath"><acronym def="XPath">XPath</acronym></xsl:template>
<xsl:template match="xinclude"><acronym def="XInclude">XInclude</acronym></xsl:template>
<xsl:template match="markdown"><acronym def="markdown">Markdown</acronym></xsl:template>
<xsl:template match="xsl"><acronym def="eXtensible Stylesheet Language">XSL</acronym></xsl:template>
<xsl:template match="c"><acronym def="C programming language">C</acronym></xsl:template>
<xsl:template match="cpp"><acronym def="C++ programming language">C++</acronym></xsl:template>
<xsl:template match="sql"><acronym def="Structured Query Language">SQL</acronym></xsl:template>
<xsl:template match="oracle"><acronym def="Oracle Database System">Oracle</acronym></xsl:template>
<xsl:template match="mysql"><acronym def="MySQL Database System">MySQL</acronym></xsl:template>
<xsl:template match="postgres"><acronym def="Postgres Database System">Postgres</acronym></xsl:template>
<xsl:template match="ecmascript"><proglang><acronym def="ECMAScript">ECMAScript</acronym></proglang></xsl:template>
<xsl:template match="flash"><proglang><acronym def="Flash">Flash</acronym></proglang></xsl:template>
<xsl:template match="actionscript"><proglang><acronym def="ActionScript">ActionScript</acronym></proglang></xsl:template>
<xsl:template match="rss"><acronym def="Real Simple Syndication">RSS</acronym></xsl:template>
<xsl:template match="atom"><acronym def="">Atom</acronym></xsl:template>
<xsl:template match="kml"><acronym def="Keyhole Markup Language"><markupLang>KML</markupLang></acronym></xsl:template>
<xsl:template match="http"><acronym def="HyperText Transfer Protocol">HTTP</acronym></xsl:template>
<xsl:template match="https"><acronym def="Secure HyperText Transfer Protocol">HTTPS</acronym></xsl:template>
<xsl:template match="ftp"><acronym def="File Transfer Protocol">FTP</acronym></xsl:template>
<xsl:template match="java"><proglang><acronym def="Java">Java</acronym></proglang></xsl:template>


<xsl:include href="shorthand.xsl"/>
<xsl:include href="glossaryTable.xsl"/>
<xsl:include href="linkTable.xsl"/>
<xsl:include href="../common/xml-to-string.xsl"/>

<xsl:output method="xml"
            cdata-section-elements=""/>

<!-- copy everything through by default. -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="img">
<graphic format="PNG"><xsl:attribute name="fileref"><xsl:value-of select="@src"/></xsl:attribute></graphic>
</xsl:template>

<!-- Allow for a verbatim XML/HTML that is protected by putting  -->
<xsl:template match="verbXML">
<programlisting lang="xml">
<xsl:text>&#10;</xsl:text>
<xsl:call-template name="xml-to-string">
<xsl:with-param name="node-set" select="./*[1]"/>
</xsl:call-template>
<xsl:text>&#10;</xsl:text>
</programlisting>
</xsl:template>


</xsl:stylesheet>


