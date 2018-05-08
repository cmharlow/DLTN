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
            
            <xsl:if test="dc:date|dc:source">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:source" mode="place"/> <!-- place of origin sometimes -->
                    <xsl:apply-templates select="dc:publisher"/>
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
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/> <!-- thumbnail url -->
                    <xsl:apply-templates select="dc:source" mode="repository"/>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:subject"/> <!-- subject -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:call-template name="rightsRepair"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic subject info, 1 temporal -->
            <xsl:apply-templates select="dc:format" mode="type"/> <!-- item types -->
            <xsl:apply-templates select="dc:relation" mode="identifiers"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Nineteenth Century Agricultural Resources</title>
                </titleInfo>
                <abstract>The selection of materials in this collection portrays the lives of Tennessee’s average farmers in the nineteenth and early twentieth centuries.  These images illustrate the development of agricultural practices and methods over a period of more than a century, from Tennessee immigration in the 1830s to the Depression era of the 1930s.  These documents reflect the earliest authors and record keepers’ materials that encouraged immigration for the purpose of agricultural life and encouraged various crop production based on diverse natural resources and advances in the “technology” of nineteenth-century farming.  Photographs of farmers at their trade as well as various other ephemera, including pamphlets, newsletters, and clippings, all highlight the significance of agriculture to the economy and history of Tennessee as it evolved from an untamed wilderness to a thriving member of the New South...</abstract>
                <location>
                    <url>http://cdm15138.contentdm.oclc.org/cdm/landingpage/collection/agricult</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
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
    </xsl:template>
    
    <xsl:template match="dc:format"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
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
    
    <xsl:template match="dc:format" mode="type">
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
    
    <xsl:template match="dc:relation" mode="identifiers">
        <relatedItem>
            <identifier><xsl:value-of select="."/></identifier>
        </relatedItem>
    </xsl:template>
    
    <xsl:template match="dc:source">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(., '\d{4}')">
                        <!-- do nothing, already captured in date -->
                    </xsl:when>
                    <xsl:when test="matches(., 'Historic Sites')">
                        <!-- do nothing, note sure what to do with this -->
                    </xsl:when>
                    <xsl:when test="contains(., 'County')">
                        <!-- handle in source mode place -->
                    </xsl:when>
                    <xsl:when test="starts-with(., 'Vol')">
                        <part>
                            <detail>
                                <number><xsl:value-of select="normalize-space(.)"/></number>
                            </detail>
                        </part>
                    </xsl:when>
                    <xsl:when test="contains(., 'Society') or contains(., 'State Library') or contains(., 'Tennessee Valley Authority')">
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
    
    <xsl:template match="dc:source" mode="place">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and contains(., 'County')">
                <place><xsl:value-of select="normalize-space(.)"/></place>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:source" mode="repository">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and (contains(., 'Society') or contains(., 'State Library') or contains(., 'Tennessee Valley Authority'))">
                <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
