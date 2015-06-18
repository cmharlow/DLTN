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
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes, forms  -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/> <!-- thumbnail URL -->
                    <xsl:apply-templates select="dc:identifier" mode="shelfLocator"/> <!-- shelf locator parsed from identifier -->
                    <xsl:apply-templates select="dc:source" mode="repository"/><!-- physicalLocation-->
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="genre"/> <!-- genre -->
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/> <!-- collections -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>German Heritage</title>
                </titleInfo>
                <abstract>The German Heritage Collection is a combination of several individual collections and items that have been donated to the library over the years. Combined, the items in the collection offer a glimpse at the lives of first- and second-generation German immigrants in Memphis and the impact this group had upon Memphis in the 19th and 20th centuries. The Dorman-Weiner collection was donated in 2006 by Mrs. Juliette Dorman and includes family photos, clippings, documents and letters from the family of Charles A. Wiener. The letters, in English and German, provide details about the lives of Wiener relatives in post-World War II Germany. The Soehner photos and documents were donated by Mrs. Ernestine O. Soehner and include information on the Soehner family from 1860s to 1920s. Several photos of Memphis in 1898 are part of this donation. The Witzmann collection includes immigration documents, portraits of Emile Witzmann and advertisements for Witzmann pianos. Additional information on Emile Witzmann can be found in the Witzmann Collection housed in the Memphis and Shelby County Room.</abstract>
                <location>
                    <url>http://cdm16108.contentdm.oclc.org/cdm/landingpage/collection/p15342coll9</url>
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
                        <xsl:when test="contains(., 'jpeg') or contains(., 'jpg')">
                            <internetMediaType>image/jpeg</internetMediaType>
                        </xsl:when>
                        <xsl:when test="contains(., 'handwritten') or contains(., 'mounted') or contains(., 'with envelope') or matches(., 'two-sided')">
                            <note><xsl:value-of select="normalize-space(.)"/></note>
                        </xsl:when>
                        <xsl:when test="matches(., '\d+.+') or contains(., 'two ')">
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
