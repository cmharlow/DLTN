<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://worldcat.org/xmlschema/qdc-1.0/"
    exclude-result-prefixes="xs xsi oai oai_qdc dcterms dc" version="2.0">

    <!-- output settings -->
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- includes and imports -->

    <!--
    Collection/Set = TSLA sets as Qualified Dublin Core => MODS
  -->

    <!-- variables and parameters -->
    <!--
    dc:language processing parameter: there are multiple language values in the
    QDC.
  -->

    <xsl:param name="pLang">
        <l string="eng">english</l>
        <l string="eng">en</l>
        <l string="eng">eng</l>
        <l string="deu">german</l>
        <l string="spa">spanish</l>
        <l string="zxx">zxx</l>
        <l string="zxx">no linguistic content.</l>
    </xsl:param>

    <!-- identity tranform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
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
            <titleInfo>
                <title>
                    <xsl:apply-templates select="dc:title/text()"/>
                </title>
            </titleInfo>
            <recordInfo>
              <recordContentSource>Tennessee State Library &amp; Archives</recordContentSource></recordInfo>
            <accessCondition type="local rights statement">
              <xsl:apply-templates select="dc:rights"/>
            </accessCondition>
          <location>
            <xsl:apply-templates select="dc:identifier[starts-with(., 'http://')]"/>
          </location>
        </mods>
    </xsl:template>
    
    <!--rights-->
    <xsl:template match="dc:rights">
      <xsl:apply-templates/>
    </xsl:template>
  
    <!--identifier-->
    <xsl:template match="dc:identifier[starts-with(., 'http://')]">
      <xsl:variable name="identifier-preview-url" select="replace(., '/cdm/ref', '/utils/getthumbnail')"/>
      <url usage="primary" access="object in context"><xsl:apply-templates/></url>
      <url access="preview"><xsl:value-of select="$identifier-preview-url"/></url>
    </xsl:template>
  
</xsl:stylesheet>
