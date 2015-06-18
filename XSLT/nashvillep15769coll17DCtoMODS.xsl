<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="nashvilleDCtoMODS.xsl"/>
    <xsl:include href="../!thumbnails/ContentDMthumbnailDCtoMODS.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>StoryCorps @ Your Library</title>
                </titleInfo>
                <location>
                    <url>http://nashville.contentdm.oclc.org/cdm/landingpage/collection/p15769coll17</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
    
</xsl:stylesheet>
