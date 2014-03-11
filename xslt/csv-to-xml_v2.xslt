<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="fn"
  exclude-result-prefixes="xs fn">

  <!--
  Convert a text file in Comma-Separated Format (CSV)
  to a similar structure in XML format

  Input: Any XML (e.g., the stylesheet itself)
  Input Parameters:
    * csv - string, path to the input CSV file,
            absolute or relative to the stylesheet
    * encoding - optional, string, character encoding of the input CSV file,
                 defaults to 'UTF-8'

  Output: XML format with a structure similar to CSV

  This stylesheet is adapted from:
  "A CSV to XML converter in XSLT 2.0", by Andrew Welch
  http://andrewjwelch.com/code/xslt/csv/csv-to-xml_v2.html

  For the modified stylesheet,
  Author: Eric Bréchemier
  License: http://creativecommons.org/licenses/by/4.0/
  Version: 2014-03-11
  -->

  <xsl:output indent="yes" encoding="US-ASCII"/>

  <xsl:param name="pathToCSV" select="'file:///c:/csv.csv'"/>

  <xsl:function name="fn:getTokens" as="xs:string+">
    <xsl:param name="str" as="xs:string"/>
      <xsl:analyze-string
        select="concat($str, ',')"
        regex='(("[^"]*")+|[^,]*),'
      >
        <xsl:matching-substring>
          <xsl:sequence
            select='replace(regex-group(1), "^""|""$|("")""", "$1")'
          />
        </xsl:matching-substring>
      </xsl:analyze-string>
  </xsl:function>

  <xsl:template match="/" name="main">
    <xsl:choose>
      <xsl:when test="unparsed-text-available($pathToCSV)">
        <xsl:variable name="csv" select="unparsed-text($pathToCSV)"/>
        <xsl:variable name="lines" as="xs:string+"
          select="tokenize($csv, '&#xa;')"
        />
        <xsl:variable name="elemNames" as="xs:string+"
          select="fn:getTokens($lines[1])"
        />
        <root>
          <xsl:for-each select="$lines[position() > 1]">
            <row>
              <xsl:variable name="lineItems" as="xs:string+"
                select="fn:getTokens(.)"
              />

              <xsl:for-each select="$elemNames">
                <xsl:variable name="pos" select="position()"/>
                <elem name="{.}">
                  <xsl:value-of select="$lineItems[$pos]"/>
                </elem>
              </xsl:for-each>
            </row>
          </xsl:for-each>
        </root>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Cannot locate : </xsl:text><xsl:value-of select="$pathToCSV"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
