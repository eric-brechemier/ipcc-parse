<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:json="http://eric.brechemier.name#json"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
>
  <!--
  Transform JSON XML to JSONP ("JSON with Padding") text

  Input: JSON XML
  Output: JSON text wrapped in a function call or other JavaScript code
          to allow direct loading from a script element in an HTML page

  Parameters:
    * wrapperStart - optional, string, start of wrapping code,
                     defaults to 'jsonp('
    * wrapperEnd - optional, string, end of wrapping code,
                   defaults to ');'
    * EMPTY - optional, string, value to output for the empty string "",
              defaults to '""'
    * TRUE - optional, string, value to output for boolean value true,
             defaults to 'true'
    * FALSE - optional, string, value to output for boolean value false,
              defaults to 'false'
    * NULL - optional, string, value to output for the null value,
             defaults to 'null'

  The values TRUE, FALSE and NULL can be customized to get a more
  compact representation, e.g., by defining the following aliases:

     // aliases for compact values in JSONP
     var E="", T=true, F=false, N=null;

  setting 'T', 'F', and 'N' to the parameters 'TRUE', 'FALSE', and 'NULL'
  will use short aliases instead of the long values that they represent.

  Author: Eric Bréchemier
  License: http://creativecommons.org/licenses/by/4.0/
  Version: 2014-03-11
  -->

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:param name="wrapperStart" as="xs:string" select="'jsonp('" />
  <xsl:param name="wrapperEnd" as="xs:string" select="');'" />

  <xsl:param name="EMPTY" as="xs:string">""</xsl:param>
  <xsl:param name="TRUE" as="xs:string">true</xsl:param>
  <xsl:param name="FALSE" as="xs:string">false</xsl:param>
  <xsl:param name="NULL" as="xs:string">null</xsl:param>

  <xsl:template match="/">
    <xsl:value-of select="$wrapperStart" />
    <xsl:apply-templates />
    <xsl:value-of select="$wrapperEnd" />
  </xsl:template>

  <xsl:template match="json:object">
    <xsl:text>{</xsl:text>
      <xsl:apply-templates mode="list" select="json:*" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="json:property">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>":</xsl:text>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="json:array[not(json:*)]">
    <xsl:text>A</xsl:text>
  </xsl:template>

  <xsl:template match="json:array[count(json:*)=1 and json:null]">
    <xsl:text>I</xsl:text>
  </xsl:template>

  <xsl:template match="json:array">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates mode="list" select="json:*" />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template mode="list" match="json:*">
    <xsl:apply-templates select="." />
    <xsl:if test=" position()!=last() ">
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="json:string">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="json:number">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="json:string[.='']">
    <xsl:value-of select="$EMPTY" />
  </xsl:template>

  <xsl:template match="json:true">
    <xsl:value-of select="$TRUE" />
  </xsl:template>

  <xsl:template match="json:false">
    <xsl:value-of select="$FALSE" />
  </xsl:template>

  <xsl:template match="json:null">
    <xsl:value-of select="$NULL" />
  </xsl:template>

  <xsl:template mode="list" match="text()" />
  <xsl:template match="text()" />

</xsl:transform>
