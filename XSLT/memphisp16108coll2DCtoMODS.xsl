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
            
            <xsl:if test="dc:identifier">
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
                    <title>Perre Magness Collection</title>
                </titleInfo>
                <abstract>Perre Magness is an avid volunteer, historian, and writer. Magness has served many volunteer positions in Memphis, including the founding president of the Volunteer Center of Memphis, President of the Junior League of Memphis, and a board member of LeMoyne-Owen College. In the 1960s, she served on the historic Panel of American Women, helping women learn to overcome racial, religious, and socioeconomic differences. In addition to her philanthropy work, she reviewed books for the Nashville Banner and the Commercial Appeal for several years before she started writing her own column. "Past Times" began in 1987 and was printed in the Commercial Appeal for sixteen years. She also has written ten books, her first one published in 1983. Most of her books are about Memphis and the Mid-South, but topics of these books range. Notable books she has written include Past Times: Stories of Early Memphis, and books about Memphis landmarks, such as In the Shadows of the Elms: Elmwood Cemetery, which won the Memphis Heritage Historical Writing Award in 2002....</abstract>
                <location>
                    <url>http://cdm16108.contentdm.oclc.org/cdm/landingpage/collection/p16108coll2</url>
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
                        <xsl:when test="matches(., '\d+.+') or contains(., 'eight') or contains(., 'eleven') or contains(., 'five') or contains(., 'four') or contains(., 'fourteen') or contains(., 'nine') or contains(., 'one ') or contains(., 'seven') or contains(., 'six') or contains(., 'ten') or contains(., 'three') or contains(., 'two ')">
                            <extent><xsl:value-of select="normalize-space(.)"/></extent>
                        </xsl:when>
                        <xsl:when test="matches(., 'handwritten') or matches(., 'two-sided') or matches(., 'typed') or matches(., 'various sizes')">
                            <note><xsl:value-of select="normalize-space(.)"/></note>
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
