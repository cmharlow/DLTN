<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:include href="knoxpublicdctomods.xsl"/>
    <xsl:include href="coredctomods.xsl"/>
    <xsl:include href="contentdmthumbnaildctomods.xsl"/>
    
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
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
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
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/>
                </location>
            </xsl:if>
            
            <xsl:call-template name="photocollLanguage"/>
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:call-template name="dc:rightsTypoRepair"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:type" mode="genre"/> <!-- genres -->
            <xsl:apply-templates select="dc:source"/> <!-- collections -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>The Knox County Two Centuries Photograph Collection</title>
                </titleInfo>
                <abstract>During the celebration of Knox County’s two hundredth birthday in 1992, the Calvin M. McClung Historical Collection of the Knox County Public Library System copied over 3,000 photographs owned by over 230 Knox County citizens and organizations. The aim of the project was to collect as large a body of photographs as possible documenting Knox County from the early days of photography in the 1840s to the 1970s. Library staff went on-site to 28 locations in Knox County on 44 different days during 1991. The resulting collection of photographs documents the daily lives of individuals, families, communities, and institutions of Knox County during two centuries. The book Two Centuries of Knox County, Tennessee: A Celebration in Photographs, published in 1992 by the Friends of the Knox County Public Library, was able to offer only a small cross section of the hundreds of photographs copied during this project.</abstract>
                <location>
                    <url>http://cdm16311.contentdm.oclc.org/cdm/landingpage/collection/p265301coll005</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordInfo"/> <!-- record info for Knoxville Public Libraries collections -->
        </mods>
    </xsl:template>
    
    <!-- Typo Repairs, Static Additions -->
    
    <xsl:template name="dc:rightsTypoRepair">
        <accessCondition>To use photographs or to order reproductions, contact DigitalCollections@knoxlib.org or phone 865 215-8808. Please refer to Image Number and provide a brief description of the photograph.</accessCondition>
    </xsl:template>
    
    <xsl:template name="photocollLanguage">
        <language>
            <languageTerm type="code" authority="iso639-2b">zxx</languageTerm>
        </language>
    </xsl:template>
    
</xsl:stylesheet>
