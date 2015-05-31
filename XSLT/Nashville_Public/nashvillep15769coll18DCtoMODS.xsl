<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="nashvilleDCtoMODS.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:contributor|dc:publisher|dc:creator">
                <originInfo> 
                    <publisher>Special Collections Division of the Nashville Public Library, 615 Church Street, Nashville, Tennessee, 37219</publisher>
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type|dc:source">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                    <xsl:apply-templates select="dc:source" mode="physicalNote"/> <!-- some physical notes type fields -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:publisher|dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:publisher" mode="repository"/>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:publisher" mode="rights"/>
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/><!-- genre -->
            <typeOfResource>sound recording</typeOfResource>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Nashville's New Faces</title>
                </titleInfo>
                <abstract>A series of interviews conducted with recent immigrants and first generation Americans in Nashville. The collection includes conversations with people from 27 countries, including our Latino, Somali, Laotian, Kurdish, Vietnamese, Sudanese, and other foreign-born and immigrant communities. In the interviews, participants were invited to bring a friend or family member and discuss whatever they wished. This resulted in a wide variety of conversations covering immigration, identity, love, family, education, and more. This project was conducted as part of a StoryCorps @ your library pilot program.</abstract>
                <location>
                    <url>http://nashville.contentdm.oclc.org/cdm/landingpage/collection/p15769coll18</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
    
</xsl:stylesheet>
