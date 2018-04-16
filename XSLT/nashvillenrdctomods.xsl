<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="nashvilledctomods.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:contributor" /> <!-- name/role -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:contributor|dc:publisher|dc:creator">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:contributor" mode="date" /> <!-- stray dates in contributor field -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                    <xsl:apply-templates select="dc:contributor" mode="publisher" /> <!-- publisher of physical item parsed form contributor field -->
                    <xsl:apply-templates select="dc:creator" mode="publisher" /> <!-- publisher of physical item parsed form creator field -->
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
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:call-template name="rightsRepair"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:publisher" mode="rights"/>
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic subject info -->
            <xsl:apply-templates select="dc:type"/><!-- genre -->
            <xsl:apply-templates select="dc:source"/>
            <xsl:apply-templates select="dc:type" mode="type"/> <!-- item types -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Nashville Public Library Digital Collection</title>
                </titleInfo>
                <location>
                    <url>http://nashville.contentdm.oclc.org/cdm/landingpage/collection/nr</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
    
    <xsl:template name="rightsRepair">
        <xsl:choose>
            <xsl:when test="dc:rights!='' and not(starts-with(dc:rights, 'unde'))">
                <!--<accessCondition type='local rights statement'><xsl:value-of select="normalize-space(dc:rights)"/></accessCondition>-->
                <xsl:apply-templates select="dc:rights[not(starts-with(., 'unde'))]"/>
            </xsl:when>
            <xsl:otherwise>
                <accessCondition type='local rights statement'>For rights information of this object, please contact: Metro Nashville Archives, 615 Church Street, Nashville, Tennessee, 37219. Telephone (615) 862-5880.</accessCondition>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
