<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="tsladctomods.xsl"/>
        
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:creator"/> <!-- creator -->
            
            <xsl:if test="dc:date">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- internetMediaType -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier|dc:source">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/> <!-- thumbnail url -->
                    <xsl:apply-templates select="dc:source" mode="repository"/>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:subject"/> <!-- subject -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:call-template name="rightsRepair"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic subject info -->
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/> <!-- collection -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Tennessee State Parks Folklife Project Collection, 1979-1984</title>
                </titleInfo>
                <abstract>The Tennessee State Parks Folklife Project produced more than 500 hours of audio tape, 9600 slides, and 2200 black and white negatives, including duplicates of scores of historic photographs which had been cached for years by their owners. Several years ago, TSLA initiated a project to digitize selections of the audio recordings and photographs from the collection in order to improve public access. The recordings, held originally on reel-to-reel and cassettes, and the accompanying photographs, include material on traditional quilting, burial customs, storytelling, blacksmithing, herbal medicine, fishing, logging, farming techniques, and music. Nationally recognized ballad singers Dee and Delta Hicks and Joe, Ethel, and Creed Birchfield (founding members of the Roan Mountain Hilltoppers) are just a few of the musical artists featured in the collection. To date, the bulk of the collection remains unprocessed and in the original formats. Approximately twenty percent of the audio recordings have been digitized. The recordings and images found in this TeVA collection represent just a sample of the rich material yet to be discovered. The digitization project is ongoing, and we will add items as they become available.</abstract>
                <location>
                    <url>http://www.tn.gov/tsla/TeVAsites/TSPFolklife/index.htm</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='unknown'">
                <xsl:choose>
                    <xsl:when test="matches(., '\d+')">
                        <subject>
                            <temporal><xsl:value-of select="normalize-space(.)"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="SpatialTopic">
                            <xsl:with-param name="term"><xsl:value-of select="."/></xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image/jpeg') or matches(normalize-space(lower-case(.)), 'image/jpg') or matches(normalize-space(lower-case(.)), 'jpeg') or matches(normalize-space(lower-case(.)), 'jpg')">
                        <internetMediaType>image/jpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image/jp2')">
                        <internetMediaType>image/jp2</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'tiff')">
                        <internetMediaType>image/tiff</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'wmv')">
                        <internetMediaType>video/x-ms-wmv</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'mp3')">
                        <internetMediaType>audio/mp3</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'wav')">
                        <internetMediaType>audio/wav</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '\d+')">
                        <extent><xsl:value-of select="normalize-space(.)"/></extent>
                    </xsl:when>
                    <xsl:otherwise>
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="rightsRepair">
        <xsl:choose>
            <xsl:when test="dc:rights">
                <accessCondition><xsl:value-of select="normalize-space(.)"/></accessCondition>
            </xsl:when>
            <xsl:otherwise>
                <accessCondition>While TSLA houses an item, it does not necessarily hold the copyright on the item, nor may it be able to determine if the item is still protected under current copyright law. Users are solely responsible for determining the existence of such instances and for obtaining any other permissions and paying associated fees, that may be necessary for the intended use.</accessCondition>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
    <xsl:template match="dc:source">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(., 'State Library') or matches(., 'Tennessee Historical Society')">
                        <!-- becomes physicalLocation - repository -->
                    </xsl:when>
                    <xsl:otherwise>
                        <relatedItem type='host' displayLabel="Collection">
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                        </relatedItem>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:source" mode="repository">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and contains(., 'State Library') or matches(., 'Tennessee Historical Society')">
                <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
