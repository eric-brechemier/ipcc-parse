<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://eric.brechemier.name#csv"
  xmlns:csv="http://eric.brechemier.name#csv"
  exclude-result-prefixes="xs csv">

  <!--
  Convert a text file in Tab-Separated Format (TSV)
  to a similar structure in XML format

  Input: Any XML (e.g., the stylesheet itself)
  Input Parameters:
    * path - string, path to the input TSV file,
             absolute or relative to the stylesheet
    * encoding - optional, string, character encoding of the input TSV file,
                 defaults to 'UTF-8'

  Output: XML format with a structure similar to CSV

  This stylesheet is adapted from:
  "Example: Processing a Comma-Separated-Values File"
  p.907 in "XSLT 2.0 and XPath 2.0, 4th Edition" (ISBN: 9780470192740)
  by Michael Kay

  For the modified stylesheet,
  Author: Eric Bréchemier
  License: http://creativecommons.org/licenses/by/4.0/
  Version: 2014-03-18
  -->

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:param name="path" as="xs:string"/>
  <xsl:param name="encoding" as="xs:string" select="'UTF-8'" />

  <xsl:template match="/" name="main">
    <xsl:variable name="tsvText" select="unparsed-text($path, $encoding)"/>
    <records>
      <xsl:analyze-string select="$tsvText" regex="\n">
        <xsl:non-matching-substring>
          <record>
            <xsl:analyze-string select="." regex="\t">
              <xsl:non-matching-substring>
                <field>
                  <xsl:value-of select="." />
                </field>
              </xsl:non-matching-substring>
            </xsl:analyze-string>
          </record>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </records>
  </xsl:template>

</xsl:stylesheet>
