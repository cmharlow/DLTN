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
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="genre"/> <!-- genre -->
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/> <!-- collection -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Robert Lanier Collection</title>
                </titleInfo>
                <abstract>Robert A. Lanier was born in Memphis in 1938, and has spent most of his life in the city. His contributions to the Memphis law community began after he received his Bachelor of Science from Memphis State University (now U of M) and his law degree from the University of Mississippi, in 1960 and 1962 respectively. He was a member of the Memphis law firm of Armstrong, McAdden, Allen, Braden and Goodman from 1964-1968, as well as Farris, Hancock, Gilman, Branan, Lanier and Hellen in 1968. After his stints at these two practices, he became the director of the Memphis and Shelby County Junior Bar Association in 1969-1970, as well as secretary of that same organization in 1971. During this time, he was appointed as a special judge at both Circuit and General Sessions Courts, and the Memphis City Court. He served as a Circuit Court judge from 1982 until his retirement in 2004. Lanier also served as an Adjunct Professor at the Memphis State University School of Law (U of M) in 1981, and he was a member of the Shelby County Republican Executive Committee from 1970-1972. He was involved in the Memphis Humane Association and co-founded the Tennessee Humane Association. Starting out as director of the former in 1972, he eventually became president of both, in Memphis in 1974 and as the state’s from 1975-1977....</abstract>
                <location>
                    <url>http://cdm16108.contentdm.oclc.org/cdm/landingpage/collection/p16108coll14</url>
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
