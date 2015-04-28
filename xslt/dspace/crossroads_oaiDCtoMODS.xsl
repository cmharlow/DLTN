<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
  version="2.0" xmlns="http://www.loc.gov/mods/v3">
  <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="text()|@*"/>
  <xsl:template match="//oai_dc:dc">
    <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd" version="3.5">      
      <xsl:apply-templates select="dc:title"/>
      
      <!-- Check 'unknown' in dc:creator when well, unknown. Ignore it if present.-->
      <xsl:if test="lower-case(normalize-space(dc:creator)) != 'unknown'">
        <xsl:apply-templates select="dc:creator"/>
      </xsl:if>
      
      <!-- Check 'unknown' in dc:contributor when well, unknown. Ignore it if present.-->
      <xsl:if test="lower-case(normalize-space(dc:contributor[0])) != 'unknown'">
        <xsl:apply-templates select="dc:contributor"/>
      </xsl:if>
      
      <xsl:if test="normalize-space(dc:date[0]) != ''">      
        <originInfo>
          <!-- Check for 'unknown' in dc:date. Ignore it if present.-->
          <xsl:if test="lower-case(normalize-space(dc:date)) != 'unknown'">
            <xsl:apply-templates select="dc:date" mode="dltn"/>
          </xsl:if>
        </originInfo>
      </xsl:if>
            
      <xsl:apply-templates select="dc:description"/>
            <!-- templates we override get a mode attribute with the setSpec of the collection -->
      <xsl:apply-templates select="dc:identifier" mode="dltn"/>
      <xsl:apply-templates select="dc:rights"/>
      <xsl:apply-templates select="dc:subject" />


      <xsl:apply-templates select="dc:coverage" mode="dltn"/>
      <xsl:apply-templates select="dc:type" mode="dltn"/>
      <xsl:apply-templates select="dc:relation" />
      <xsl:call-template name="repository">
        <xsl:with-param name="repository">rhodes College</xsl:with-param>
      </xsl:call-template>
    <xsl:apply-templates select="dc:relation"/>
    </mods>
  </xsl:template>
  
  <!-- utility templates -->
  <xsl:include href="../dltn_templates.xsl"/>
  
  <!-- dublin core field templates -->
  <xsl:include href="../dspace_template.xsl"/>
  
</xsl:stylesheet>

