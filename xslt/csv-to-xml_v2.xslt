<?xml version="1.0"?>
<!--
	A CSV to XML transform
	Version 2
	Andrew Welch
	http://andrewjwelch.com
	
	Modify or supply the $pathToCSV parameter and run the transform
	using "main" as the initial template.
	
	For bug reports or modification requests contact me at andrew.j.welch@gmail.com
-->
  		
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="fn"
	exclude-result-prefixes="xs fn">

<xsl:output indent="yes" encoding="US-ASCII"/>

<xsl:param name="pathToCSV" select="'file:///c:/csv.csv'"/>

<xsl:function name="fn:getTokens" as="xs:string+">
	<xsl:param name="str" as="xs:string"/>
		<xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
			<xsl:matching-substring>
				<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
			</xsl:matching-substring>
		</xsl:analyze-string>
</xsl:function>

<xsl:template match="/" name="main">
	<xsl:choose>
		<xsl:when test="unparsed-text-available($pathToCSV)">
			<xsl:variable name="csv" select="unparsed-text($pathToCSV)"/>
			<xsl:variable name="lines" select="tokenize($csv, '&#xa;')" as="xs:string+"/>
			<xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
			<root>
				<xsl:for-each select="$lines[position() > 1]">
					<row>
						<xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>

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