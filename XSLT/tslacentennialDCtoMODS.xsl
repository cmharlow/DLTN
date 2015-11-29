<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="tsladctomods.xsl"/>
        
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <!-- if statement blocks output of TSLA records that are at item/part-level-->
        <xsl:if test="not(matches(dc:title/text(), '_\d+$'))">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:creator"/> <!-- creator -->
            <xsl:apply-templates select="dc:contributor"/> <!-- contributors -->
            
            <xsl:if test="dc:date">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:call-template name="publisherRepair"/> <!-- publisher with places parsed out (already separate publ fields in orig data -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- internetMediaType, extent -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier">
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
            <xsl:apply-templates select="dc:relation"/> <!-- related urls, ids -->
            <xsl:apply-templates select="dc:source"/> <!-- collection -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Tennessee Centennial Exposition</title>
                </titleInfo>
                <abstract>In 1897, Tennessee held a six-month celebration to mark the one-hundredth anniversary of statehood.  The Tennessee Centennial Exposition was held in Nashville from May 1 until October 30, 1897, although the state’s actual centennial occurred in 1896.  The images in this collection primarily depict the array of buildings and individuals involved with this celebration, and are drawn from various record groups in the holdings of the Tennessee State Library and Archives.  Other interesting ephemera relating to the Centennial Exposition is also displayed, including a rare cyanotype of a building at the exhibition’s Vanity Fair....</abstract>
                <location>
                    <url>http://cdm15138.contentdm.oclc.org/cdm/landingpage/collection/Centennial</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
        </xsl:if>
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
                    <xsl:when test="matches(., '\d+')">
                        <extent><xsl:value-of select="normalize-space(.)"/></extent>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image/jpeg')">
                        <internetMediaType>image/jpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'tiff')">
                        <internetMediaType>image/tiff</internetMediaType>
                    </xsl:when>
                    <xsl:otherwise>
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="publisherRepair">
        <xsl:for-each select="tokenize(normalize-space(dc:publisher/text()), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(., 'Meadville') or contains(., 'Nashville') or contains(., 'Washington')">
                        <place><xsl:value-of select="normalize-space(.)"/></place>
                    </xsl:when>
                    <xsl:otherwise>
                        <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:relation">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <relatedItem>
                    <xsl:choose>
                        <xsl:when test="contains(., 'http')">
                            <location>
                                <url><xsl:value-of select="normalize-space(.)"/></url>
                            </location>
                        </xsl:when>
                        <xsl:otherwise>
                            <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
                        </xsl:otherwise>
                    </xsl:choose>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
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
            <xsl:if test="normalize-space(.)!='' and (matches(., 'Tennessee Historical Society') or contains(., 'State Library'))">
                <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image') or contains(lower-case(.), 'tiff')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
