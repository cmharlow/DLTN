<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="memphisdctomods.xsl"/>
    
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
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:contributor" mode="publisher"/> <!-- publisher parsed from contributor -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier|dc:source">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                    <xsl:apply-templates select="dc:identifier" mode="shelfLocator"/> <!-- shelf locator parsed from identifier -->
                    <xsl:apply-templates select="dc:source" mode="repository"/><!-- physicalLocation-->
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Roy Cajero Photograph Collection</title>
                </titleInfo>
                <abstract>The notable and the unknown. The famous and the infamous. As both artist and journalist, Roy Cajero captures them all and ultimately shows us the soul of Memphis.  Primarily portraiture, this collection of 211 images gives us a glimpse at the faces of Memphis over the span of the past four decades.  Musicians, artists, writers... athletes, politicians... they're all here.  Along with so much more.</abstract>
                <location>
                    <url>http://cdm16108.contentdm.oclc.org/cdm/landingpage/collection/p16108coll6</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordInfo"/>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:format">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:for-each select="tokenize(., ',')">
                <xsl:if test="normalize-space(.)!=''">
                    <xsl:choose>
                        <xsl:when test="matches(., '\d+.+')">
                            <extent><xsl:value-of select="normalize-space(.)"/></extent>
                        </xsl:when>
                        <xsl:otherwise>
                            <form><xsl:value-of select="normalize-space(.)"/></form>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
