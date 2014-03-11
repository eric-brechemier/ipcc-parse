<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

<xsl:param name="input-uri" as="xs:string"/>
<xsl:output indent="yes"/>

<xsl:template name="main">
  <xsl:variable name="in" 
              select="unparsed-text($input-uri, 'iso-8859-1')"/>
  <table>
  <xsl:analyze-string select="$in" regex="\n">
    <xsl:non-matching-substring>
      <row>
      <xsl:analyze-string select="." 
              regex='("([^"]*?)")|([^,]+?),'>
        <xsl:matching-substring>
          <cell>
             <xsl:value-of select="regex-group(2)"/>
             <xsl:value-of select="regex-group(3)"/>
          </cell>
        </xsl:matching-substring>
      </xsl:analyze-string>
      </row>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
  </table>
</xsl:template>

</xsl:stylesheet>

