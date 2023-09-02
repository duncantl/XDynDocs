<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:es="http://www.elasticsearch.org"
		xmlns:json="http://www.json.org"
		xmlns:http="http://www.w3.org/Protocols"
		xmlns:r="http://www.r-project.org"				
                exclude-result-prefixes="xsl es json r http">

  <!-- 
		xmlns:curl="http://curl.haxx.se"		
      	        xmlns:fo="http://www.w3.org/1999/XSL/Format"		
		xmlns:omg="http://www.omegahat.org"
 -->

<xsl:import href="http://www.omegahat.org/XSL/docbook/expandDB.xsl"/> 
<xsl:import href="http://www.omegahat.org/XSL/common/utils.xsl"/> 

<xsl:param name="draft.mode" select="0"/>
<xsl:param name="show.comments" select="$draft.mode"/>
<xsl:param name="show.fix.content" select="0"/>
<xsl:param name="show.fix" select="0"/>

<xsl:template match="ignore | altImplementation"/>

<xsl:template match="programlisting[@contentType='R']">
<r:code>
<xsl:apply-templates/>
</r:code>
</xsl:template>

<xsl:template match="http:get"><http:op>GET</http:op></xsl:template>
<xsl:template match="http:post"><http:op>POST</http:op></xsl:template>
<xsl:template match="http:put"><http:op>PUT</http:op></xsl:template>


<xsl:template match="proglisting">
<programlisting>
<xsl:apply-templates/>
</programlisting>
</xsl:template>

<xsl:template match="file">
<filename><xsl:apply-templates/></filename>
</xsl:template>

<xsl:template match="//chapter//biblioentry/@id"></xsl:template>


<xsl:template match="functionSummary">
<section>
<title>Summary of Functions</title>
<xsl:apply-templates/>
</section>
</xsl:template>

<xsl:template match="stringLiteral"><literal>"<xsl:value-of select="."/>"</literal></xsl:template>

<xsl:template match="http:DELETE|http:delete|http:PUT|http:put|http:head|http:HEAD"><http:op><xsl:value-of select="translate(local-name(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></http:op></xsl:template>
<!--
<xsl:template match="curl:opt">
<indexentry><primary>curl options</primary><secondary><xsl:value-of select="."/></secondary></indexentry>
<xsl:copy-of select="."/>
</xsl:template>-->


<!-- no longer needed
<xsl:template match="graphic">
<graphic>
 <xsl:copy-of select="@width"/>
 <xsl:copy-of select="@heigth"/>
 <xsl:attribute name="fileref">OAuth/<xsl:value-of select="@fileref"/></xsl:attribute>
</graphic>
</xsl:template>
-->

<!-- Turn the chapter bibliography into a Further Reading section and remove the id's 
     so the citations won't go to those. -->
<xsl:template match="/chapter/bibliography">
<section><title>Further Reading</title>
<xsl:apply-templates/>
</section>
</xsl:template>
<xsl:template match="/chapter/bibliography/biblioentry/@id" />


<!-- <xsl:template match="gearth"><index>Google Earth</index></xsl:template> -->
<xsl:template match="gmaps"><index>Google Maps</index></xsl:template>
<xsl:template match="gdocs"><index>Google Docs</index></xsl:template>
<xsl:template match="kiva"><index>Kiva</index></xsl:template>


<!--<xsl:template match="css"><proglang><acronym defn="Cascading Style Sheets">CSS</acronym></proglang></xsl:template>-->

<!--
<xsl:template match="xmlrpc">XML-RPC</xsl:template>
<xsl:template match="cran">CRAN</xsl:template>
<xsl:template match="es">ElasticSearch</xsl:template>
<xsl:template match="xlink">XLink</xsl:template>
<xsl:template match="xinclude">XInclude</xsl:template>
<xsl:template match="xquery">XQuery</xsl:template>
<xsl:template match="bioc">BioConductor</xsl:template>
-->

<xsl:template match="es:field"><xsl:apply-templates/></xsl:template>
<xsl:template match="RSS"><acronym def="Real Simple Syndication" index="true">RSS</acronym></xsl:template>
<xsl:template match="sax|SAX"><acronym def="Simple API for XML" index="true">SAX</acronym></xsl:template>
<xsl:template match="dom|DOM"><acronym def="Document Object Model" index="true">DOM</acronym></xsl:template>


<xsl:template match="url"><acronym def="Uniform Resource Locator">URL</acronym></xsl:template>
<xsl:template match="pmml"><acronym def="Predictive Modeling Markup Language"><markupLang>PMML</markupLang></acronym></xsl:template>


<!-- <xsl:attribute name="status"><xsl:value-of select="@status"/></xsl:attribute> -->
<!-- <xsl:template match="section/title[@status]"><title>[<xsl:value-of select="@status"/>] <xsl:apply-templates/></title></xsl:template>-->

<xsl:template match="menu"><menuchoice><xsl:apply-templates/></menuchoice></xsl:template>


<!-- <xsl:template match="q"><xsl:if test="$draft.mode">¿¿¿¿¿<comment><xsl:apply-templates/></comment>????</xsl:if></xsl:template> -->

<!-- <overview> is for explaining the flow of the chapter, but only for the authors, i.e. in draft.mode -->
<xsl:template match="overview">
<xsl:if test="$draft.mode">
<section><title>Draft Narrative</title>
<xsl:apply-templates/>
</section>
</xsl:if>
</xsl:template>

<xsl:template match="programlisting[not(@contentType)]|proglisting[not(@contentType)]">
<programlisting contentType="XML">
<xsl:apply-templates/>
</programlisting>
</xsl:template>



<xsl:template match="json:code">
<programlisting contentType="JSON">
<xsl:apply-templates/>
</programlisting></xsl:template>

<!--
<xsl:template match="json:expr"><xsl:apply-templates/></xsl:template>
<xsl:template match="json:null">null</xsl:template>
<xsl:template match="json:false">false</xsl:template>
<xsl:template match="json:true">true</xsl:template>
-->


<xsl:template match="duncan[@status='done']"/>
<xsl:template match="duncan|deb"/>

<xsl:template xmlns:g="GabeAnnotations"  match="g:*"/>

<xsl:template match="check" />

<xsl:template match="extensions">
<section>
<title>Possible Enhancements and Extensions</title>
 <xsl:apply-templates/>
</section>
</xsl:template>

<xsl:template match="extensions/topic">
<formalpara>
 <xsl:apply-templates/>
</formalpara>
</xsl:template>

<!--<xsl:template match="rest">\acronym{REST}</xsl:template>-->

<!-- <ltx>%</ltx> -->
<xsl:template match="fix|fixme"><xsl:if test="$show.fix"><xsl:message>&lt;fix&gt; ***FIXME*** <xsl:value-of select="ancestor::chapter/@id"/>: <xsl:if test="$show.fix.content"><xsl:value-of select="normalize-space(.)"/></xsl:if></xsl:message></xsl:if><fix/></xsl:template>
<xsl:template match="fixCode"><xsl:message>&lt;fixCode&gt; Fix code</xsl:message>%</xsl:template>


<xsl:template match="move"><xsl:if test="$show.fix"><xsl:message>&lt;fix&gt; ***MOVE CONTENT*** <xsl:value-of select="ancestor::chapter/@id"/>: <xsl:if test="$show.fix.content"><xsl:value-of select="normalize-space(.)"/></xsl:if></xsl:message></xsl:if><fix/></xsl:template>

<xsl:template match="finish"><xsl:message>Finish!!!</xsl:message></xsl:template>

<xsl:template match="fo">FO</xsl:template>


<xsl:template match="aside"><box><xsl:apply-templates/></box></xsl:template>

<xsl:template match="ok"><xsl:apply-templates/></xsl:template>

<xsl:template match="keywords/text()"/>

<xsl:template match="ram"><acronym>RAM</acronym></xsl:template>

<xsl:template match="matt|dtl"><xsl:message><xsl:value-of select='local-name()'/></xsl:message></xsl:template>
<!-- 
<xsl:template match="r:output"/> 
363 pages w/o
425  with.  
62 pages out of 175.
-->


<!-- Map these to simple acronyms. We will igor the defn and id -->
<xsl:template match="ast"><acronym id="ast" defn="abstract syntax tree">AST</acronym></xsl:template>
<xsl:template match="api"><acronym id="api" defn="application programming interface">API</acronym></xsl:template>
<!-- -->


<xsl:template match="ranon|r:anon"><r:func>&lt;Anonymous&gt;</r:func></xsl:template>
</xsl:stylesheet>
