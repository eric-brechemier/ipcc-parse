<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csv="http://eric.brechemier.name#csv"
  xmlns:json="http://eric.brechemier.name#json"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="csv xs"
  version="2.0"
>
  <!--
  Convert CSV XML to JSON XML

  This is an intermediate step in a conversion pipeline from CSV to JSON,
  using XML as a lingua franca to introduce additional processing as needed.

  In this straightforward conversion, both the list of records and
  individual records are converted to a JSON array, and each field
  is converted to a string value.

  Write a specific transformation to replace this conversion step
  if you require a more compact or a more explicit JSON representation.

  Input: CSV XML
  Output: JSON XML

  Author: Eric Bréchemier
  License: http://creativecommons.org/licenses/by/4.0/
  Version: 2014-03-18
  -->

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="csv:records">
    <json:array>
      <xsl:apply-templates />
    </json:array>
  </xsl:template>

  <xsl:template match="csv:record">
    <json:array>
      <xsl:apply-templates />
    </json:array>
  </xsl:template>

  <xsl:template
    match="
      csv:field[
        starts-with(.,'[')
        and ends-with(.,']')
      ]
    "
  >
    <xsl:variable name="list" as="xs:string"
      select="substring(., 2, string-length(.) - 2)"
    />
    <json:array>
      <xsl:for-each select="tokenize($list, '\|' )">
        <json:string>
          <xsl:value-of select="." />
        </json:string>
      </xsl:for-each>
    </json:array>
  </xsl:template>

  <xsl:template match="csv:field">
    <json:string>
      <xsl:value-of select="." />
    </json:string>
  </xsl:template>

</xsl:transform>
