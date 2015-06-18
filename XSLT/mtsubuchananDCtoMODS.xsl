<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="mtsudctomods.xsl"/>
    
    <xsl:template match="text()|@*"/>  
    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier" mode="part"/>
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:contributor" /> <!-- name/role -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:contributor|dc:creator|dc:publisher|dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:contributor" mode="repository" /> <!-- repository of physical item parsed form contributor field -->
                    <xsl:apply-templates select="dc:creator" mode="repository" /> <!-- repository of physical item parsed form creator field -->
                    <xsl:apply-templates select="dc:publisher" mode="repository" /> <!-- repository of physical item parsed form publisher field -->
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic, temporal subject info -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/><!-- genre -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Buchanan Family collection</title>
                </titleInfo>
                <abstract>This collection documents the family of James McGill Buchanan (1919-2013), MTSU alumnus and 1986 winner of the Nobel Prize for Economics. His family has deep roots in middle Tennessee, including an 18th-century settler of Nashville and 19th-century Governor. Mr. Buchanan earned his B.S. at Middle Tennessee State Teachers College in 1940, followed by his M.A. in Economics at UT-Knoxville and his Ph.D. at the University of Chicago.</abstract>
                <location>
                    <url>http://cdm15838.contentdm.oclc.org/cdm/landingpage/collection/buchanan</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
    
</xsl:stylesheet>