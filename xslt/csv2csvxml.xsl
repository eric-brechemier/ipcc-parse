<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://eric.brechemier.name#csv"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0"
>
  <!--
  Convert a text file in Comma-Separated Format (CSV)
  to a similar structure in XML format

  WARNING: at this point, this conversion does not support escaping
  of double quotes within quoted values, e.g., "escaped "" in quoted value".

  WARNING: at this point, this conversion does not support unquoted
  empty values, for example:
  ,,,
  is expected as
  "","","",""

  Input: Any XML (e.g., the stylesheet itself)
  Input Parameters:
    * csv - string, path to the input CSV file,
            absolute or relative to the stylesheet
    * encoding - optional, string, character encoding of the input CSV file,
                 defaults to 'UTF-8'

  Output: XML format with a structure similar to CSV

  This stylesheet is adapted from the example
  "Processing a Comma-Separated-Values File", p.907-908,
  in the book "XSLT 2.0 and XPath 2.0, 4th Edition",
  by Michael Kay

  For the modified stylesheet,
  Author: Eric Bréchemier
  License: http://creativecommons.org/licenses/by/4.0/
  Version: 2014-03-11
  -->
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:param name="csv" as="xs:string"/>
  <xsl:param name="encoding" as="xs:string" select="'UTF-8'" />

  <xsl:template name="main" match="/">
    <xsl:variable
      name="csvText"
      select="unparsed-text($csv, $encoding)"
    />
    <records>
      <xsl:analyze-string select="$csvText" regex="\n">
        <xsl:non-matching-substring>
          <record>
            <!--
            TODO: allow escaping of double quotes within quoted values,
            e.g., "escaped "" in quoted value".
            -->
            <!--
            TODO: add support for unquoted empty values, at start, middle
            and end of the record. Regular expressions may no longer be
            the right tool at this point, since regular expressions which
            match an empty string are not allowed to avoid infinite recursion.
            Also, regular expressions do not provide any way to check that the
            number of fields matches the number of columns in the first row.
            -->
            <xsl:analyze-string
              select="."
              regex='("([^"]*?)")|([^,]+?)(,|$)'
            >
              <xsl:matching-substring>
                <field>
                   <xsl:value-of select="regex-group(2)" />
                   <xsl:value-of select="regex-group(3)" />
                </field>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </record>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </records>
  </xsl:template>

</xsl:stylesheet>
