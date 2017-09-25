<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
                xmlns:dcterms="http://purl.org/dc/terms"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns="http://www.loc.gov/mods/v3"
                xpath-default-namespace="http://worldcat.org/xmlschema/qdc-1.0/"
                exclude-result-prefixes="xs xsi oai oai_qdc dcterms dc"
                version="2.0">

  <!-- output settings -->
  <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- includes and imports -->

  <!--
    Collection/Set = UT Chattanooga's sets as Qualified Dublin Core => MODS
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
    <!-- document-level variables -->
    <xsl:variable name="vAC"
                  select="if ((dcterms:license and dc:rights) or (dcterms:license and not(dc:rights)))
                          then (dcterms:license)
                          else if (not(dcterms:license) and dc:rights)
                            then (dc:rights)
                            else ()"/>
    <!-- match the document root and return a MODS record -->
    <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
      <!-- title -->
      <xsl:apply-templates select="dc:title"/>
      <!-- description -->
      <xsl:apply-templates select="dc:description"/>
      <!-- subject(s) -->
      <xsl:apply-templates select="dc:subject"/>
      <!-- language(s) -->
      <xsl:apply-templates select="dc:language"/>
      <!-- identifier(s) that are not URLs -->
      <xsl:apply-templates select="dc:identifier[not(starts-with(., 'http://'))]"/>
      <!-- originInfo -->
      <originInfo>
        <!-- publisher -->
        <xsl:apply-templates select="dc:publisher"/>
      </originInfo>
      <!-- accessCondition -->
      <accessCondition type="use and reproduction" xlink:href="{$vAC}"/>
      <!-- location: physicalLocation and URLs -->
      <location>
        <xsl:apply-templates select="dc:identifier[starts-with(., 'http://')]"/>
      </location>
      <!-- type(s) that start with a capital letter -->
      <xsl:apply-templates select="dc:type[matches(., '^[A-Z]')]"/>
      <!-- relatedItem[@type='host'] -->
      <relatedItem type="host">
        <!-- dc:source -->
        <titleInfo>
          <xsl:apply-templates select="dc:source"/>
        </titleInfo>
      </relatedItem>
      <!-- physicalDescription -->
      <physicalDescription>
        <!-- formats -->
        <xsl:apply-templates select="dc:format"/>
        <!-- type(s) that start with a lower-case letter -->
        <xsl:apply-templates select="dc:type[matches(., '^[a-z]')]"/>
      </physicalDescription>
    </mods>
  </xsl:template>

  <!-- title -->
  <xsl:template match="dc:title">
    <titleInfo>
      <title><xsl:apply-templates/></title>
    </titleInfo>
  </xsl:template>

  <!-- description -->
  <xsl:template match="dc:description">
    <abstract><xsl:apply-templates/></abstract>
  </xsl:template>

  <!-- subject(s) -->
  <!-- for subjects, whether they contains a ';' or not -->
  <xsl:template match="dc:subject">
    <xsl:variable name="subj-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$subj-tokens">
      <subject>
        <topic><xsl:value-of select="normalize-space(.)"/></topic>
      </subject>
    </xsl:for-each>
  </xsl:template>

  <!-- language(s) -->
  <!--
    There are multiple dc:language elements; e.g.
      <dc:language>Spanish</dc:language>
      <dc:language>spa</dc:language>
      or
      <dc:language>English; German</dc:language>
      <dc:language>eng; deu</dc:language>
    The list of languages (pLang, above) is exhaustive for the current set of
    records. The following template matches the first dc:language element, tokenizes
    the value(s), and then does some comparisons vs the values in pLang.

  -->
  <xsl:template match="dc:language[1]">
    <xsl:variable name="lang-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$lang-tokens">
      <xsl:variable name="ltln" select="lower-case(normalize-space(.))"/>
      <xsl:choose>
        <xsl:when test="$ltln = $pLang/l">
          <languageTerm type="code" authority="iso639-2b">
            <xsl:value-of select="$pLang/l[. = $ltln]/@string"/>
          </languageTerm>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- publisher -->
  <xsl:template match="dc:publisher">
    <publisher><xsl:apply-templates/></publisher>
  </xsl:template>

  <!-- identifier(s) -->
  <!-- identifier - location processing -->
  <!-- @TODO update identifier-preview-url variable -->
  <xsl:template match="dc:identifier[starts-with(., 'http://')]">
    <xsl:variable name="identifier-preview-url" select="replace(., 'value', 'value')"/>
    <url usage="primary" access="object in context"><xsl:apply-templates/></url>
    <url access="preview"><xsl:value-of select="$identifier-preview-url"/></url>
  </xsl:template>

  <xsl:template match="dc:identifier[not(starts-with(., 'http://'))]">
    <identifier type="local"><xsl:apply-templates/></identifier>
  </xsl:template>

  <!-- type(s) starting with capital letters -->
  <xsl:template match="dc:type[matches(., '^[A-Z]')]">
    <xsl:variable name="type-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$type-tokens">
      <typeOfResource><xsl:value-of select="normalize-space(.)"/></typeOfResource>
    </xsl:for-each>
  </xsl:template>

  <!-- type(s) starting with lower-case letters -->
  <xsl:template match="dc:type[matches(., '^[a-z]')]">
    <xsl:variable name="lc-type-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$lc-type-tokens">
      <form><xsl:value-of select="$lc-type-tokens"/></form>
    </xsl:for-each>
  </xsl:template>

  <!-- source -->
  <xsl:template match="dc:source">
    <title><xsl:apply-templates/></title>
  </xsl:template>

  <!-- format(s) -->
  <!--
    For formats that contain something that resembles an xs:time, serialize
    an <extent>.
  -->
  <xsl:template match="dc:format[matches(., '\d{2}:\d{2}:\d{2}')]">
    <extent><xsl:value-of select="."/></extent>
  </xsl:template>

  <!-- for formats that may contain multiple values separated by ';' -->
  <xsl:template match="dc:format[not(matches(., '\d{2}:\d{2}:\d{2}'))]">
    <xsl:variable name="format-tokens" select="tokenize(., ';')"/>
    <xsl:for-each select="$format-tokens">
      <internetMediaType><xsl:value-of select="normalize-space(.)"/></internetMediaType>
    </xsl:for-each>
  </xsl:template>

  <!-- ignored elements -->
  <xsl:template match="dc:rights | dcterms:license"/>
  <xsl:template match="dc:language[position() > 1]"/>
</xsl:stylesheet>