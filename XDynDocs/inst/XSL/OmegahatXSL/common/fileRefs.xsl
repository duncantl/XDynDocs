<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version='1.0'>


<xsl:template name="old_makeFileRef">
 <xsl:param name="path"/>

<xsl:message>xml.base.dirs: <xsl:call-template name="xml.base.dirs"><xsl:with-param name="base.elem" select="."/></xsl:call-template></xsl:message>
<xsl:message># base = <xsl:value-of select="count(./ancestor::*[@xml:base])"/></xsl:message>

<xsl:call-template name="normalize">
 <xsl:with-param name="path"><xsl:call-template name="dirname">
  <xsl:with-param name="path" select="./ancestor::*[@xml:base]/@xml:base"/>
</xsl:call-template><xsl:value-of select="$path"/></xsl:with-param>
</xsl:call-template>
</xsl:template>

<xsl:template name="makeFileRef">
 <xsl:param name="path"/>
 <xsl:call-template name="xml.base.dirs"><xsl:with-param name="base.elem" select="."/></xsl:call-template>
</xsl:template>


<!-- From http://svn.apache.org/repos/asf/webservices/woden/Site/src/documentation/skins/common/xslt/html/pathutils.xsl  -->
<xsl:template name="dirname">
  <xsl:param name="path" />
<xsl:message>dirname: <xsl:value-of select="$path"/></xsl:message>
  <xsl:if test="contains($path, '/')">
    <xsl:value-of select="concat(substring-before($path, '/'), '/')" />
    <xsl:call-template name="dirname">
      <xsl:with-param name="path"
        select="substring-after($path, '/')" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="normalize">
  <xsl:param name="path"/>
  <xsl:variable name="path-" select="translate($path, '\', '/')"/>
<xsl:message>normalize: <xsl:value-of select="$path"/></xsl:message>

  <xsl:choose>
    <xsl:when test="contains($path-, '/../')">

      <xsl:variable name="pa" select="substring-before($path-, '/../')"/>
      <xsl:variable name="th" select="substring-after($path-, '/../')"/>
      <xsl:variable name="pa-">
        <xsl:call-template name="dirname">
          <xsl:with-param name="path" select="$pa"/>
	</xsl:call-template>
      </xsl:variable>
      <xsl:variable name="pa-th" select="concat($pa-, $th)"/>
      <xsl:call-template name="normalize">
        <xsl:with-param name="path" select="$pa-th"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$path-"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>
</xsl:stylesheet>
