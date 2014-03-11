<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://eric.brechemier.name#csv"
  xmlns:csv="http://eric.brechemier.name#csv"
  exclude-result-prefixes="xs csv">

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

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:param name="csv" as="xs:string"/>
  <xsl:param name="encoding" as="xs:string" select="'UTF-8'" />

  <xsl:function name="csv:getFields" as="xs:string+">
    <xsl:param name="record" as="xs:string"/>
      <xsl:analyze-string
        select="concat($record, ',')"
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
    <xsl:variable name="csvText" select="unparsed-text($csv, $encoding)"/>
    <xsl:variable name="records" as="xs:string+"
      select="tokenize($csvText, '&#xa;')"
    />
    <xsl:variable name="fieldNames" as="xs:string+"
      select="csv:getFields($records[1])"
    />
    <records>
      <record type="header">
        <xsl:for-each select="$fieldNames">
          <field>
            <xsl:value-of select="."/>
          </field>
        </xsl:for-each>
      </record>
      <xsl:for-each select="$records[position() > 1]">
        <record>
          <xsl:variable name="fields" as="xs:string+"
            select="csv:getFields(.)"
          />

          <xsl:for-each select="$fieldNames">
            <xsl:variable name="fieldPosition" select="position()"/>
            <field name="{.}">
              <xsl:value-of select="$fields[$fieldPosition]"/>
            </field>
          </xsl:for-each>
        </record>
      </xsl:for-each>
    </records>
  </xsl:template>

</xsl:stylesheet>
