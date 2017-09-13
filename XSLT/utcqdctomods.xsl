<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
                xmlns:dcterms="http://purl.org/dc/terms"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns="http://www.loc.gov/mods/v3"
                exclude-result-prefixes="#all"
                version="2.0">

  <!-- output settings -->
  <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- includes and imports -->

  <!--
    Collection/Set = UT Chattanooga's sets as Qualified Dublin Core => MODS
  -->

  <!-- identity tranform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- normalize all the text! -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- match oai_qdc:qualifieddc -->
  <xsl:template match="oai_qdc:qualifieddc">
    <!-- match the document root and return a MODS record -->
    <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">


    </mods>
  </xsl:template>
</xsl:stylesheet>