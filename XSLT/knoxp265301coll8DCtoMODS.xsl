<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="knoxpublicdctomods.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date[1]"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:contributor" mode="publisher"/> <!-- publisher parsed from contributor -->
                    <xsl:apply-templates select="dc:creator" mode="publisher"/> <!-- publisher parsed from creator -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form information -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:call-template name="dc:rightsTypoRepair"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="relatedItem"/>
            <xsl:apply-templates select="dc:type" mode="genre"/> <!-- genres -->
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Women's Suffrage Collection</title>
                </titleInfo>
                <abstract>Women from East Tennessee played a critical role in the women’s suffrage movement, especially Lizzie Crozier French, Mrs. Hugh L. White and Abby Crawford Milton.  The Harry T. Burn Papers related to his decisive vote in favor of women’s suffrage in the Tennessee House of Representatives in 1920 is a key component of this collection.</abstract>
                <location>
                    <url>http://cdm16311.contentdm.oclc.org/cdm/landingpage/collection/p265301coll8</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordInfo"/> <!-- record info for Knoxville Public Libraries collections -->
        </mods>
    </xsl:template>
    
    <!-- Typo Repairs, Static Additions -->
    
    <xsl:template name="dc:rightsTypoRepair">
        <accessCondition type='local rights statement'>To use material or to order reproductions, contact DigitalCollections@knoxlib.org or phone 865 215-8808. Please provide a brief description of the material.</accessCondition>
    </xsl:template>
    
    
</xsl:stylesheet>
