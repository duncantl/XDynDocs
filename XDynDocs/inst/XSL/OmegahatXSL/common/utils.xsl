<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version='1.0'>

  <!-- Taken from docbook lib/lib.xsl. When using dblatex, we get conflicts in names. -->

  <xsl:template name="trim.text">
    <xsl:param name="contents" select="."/>
    <xsl:variable name="contents-left-trimmed">
      <xsl:call-template name="trim-left">
        <xsl:with-param name="contents" select="$contents"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="contents-trimmed">
      <xsl:call-template name="trim-right">
        <xsl:with-param name="contents" select="$contents-left-trimmed"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$contents-trimmed"/>
  </xsl:template>

  <xsl:template name="trim-left">
    <xsl:param name="contents"/>
    <xsl:choose>
      <xsl:when test="starts-with($contents,'&#10;') or starts-with($contents,'&#13;') or starts-with($contents,' ') or starts-with($contents,'&#9;')">
        <xsl:call-template name="trim-left">
          <xsl:with-param name="contents" select="substring($contents, 2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$contents"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="trim-right">
    <xsl:param name="contents"/>
    <xsl:variable name="last-char">
      <xsl:value-of select="substring($contents, string-length($contents), 1)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="($last-char = '&#10;') or  ($last-char = '&#13;') or  ($last-char = ' ') or  ($last-char = '&#9;')">
        <xsl:call-template name="trim-right">
          <xsl:with-param name="contents" select="substring($contents, 1, string-length($contents) - 1)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$contents"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>