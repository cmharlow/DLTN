<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="mtsudctomods.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier" mode="part"/>
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:contributor" /> <!-- name/role -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:contributor|dc:creator|dc:publisher|dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:contributor" mode="repository" /> <!-- repository of physical item parsed form contributor field -->
                    <xsl:apply-templates select="dc:creator" mode="repository" /> <!-- repository of physical item parsed form creator field -->
                    <xsl:apply-templates select="dc:publisher" mode="repository" /> <!-- repository of physical item parsed form publisher field -->
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic, temporal subject info -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/><!-- genre -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Midlanders</title>
                </titleInfo>
                <abstract>Midlander was the student yearbook of the University from 1926 to 2004. This collection offers a complete digital copy of almost every issue.</abstract>
                <location>
                    <url>http://cdm15838.contentdm.oclc.org/cdm/landingpage/collection/p15838coll3</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
 
    <xsl:template match="dc:coverage">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="."/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-','/')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ','/')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '19th century')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes">18uu</temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '20th century')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes">19uu</temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'c. ')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'ca. ')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'between ')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="replace(replace(normalize-space(.), 'between ', ''), ' and ', '/')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'COVERAGE ')">
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'Worcester ')">
                        <subject>
                            <topical><xsl:value-of select="normalize-space(.)"/></topical>
                        </subject>
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <temporal><xsl:value-of select="normalize-space(.)"/></temporal>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format">
        <xsl:for-each select="tokenize(replace(normalize-space(.), '\)', ''), '\(')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                <!-- EXTENT -->
                    <xsl:when test="matches(normalize-space(lower-case(.)), '\d+') and not(contains(normalize-space(lower-case(.)), 'mp3')) and not(contains(normalize-space(lower-case(.)), 'jp2')) and not(contains(normalize-space(lower-case(.)), 'jpeg2000'))">
                        <extent><xsl:value-of select="normalize-space(.)"/></extent>
                    </xsl:when>
                <!-- INTERNETMEDIATYPE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'jpeg2000')">
                        <internetMediaType>image/jpeg2000</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'jpeg') or contains(normalize-space(lower-case(.)), 'jpg')">
                        <internetMediaType>image/jpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'jp2')">
                        <internetMediaType>image/jp2</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'pdf')">
                        <internetMediaType>application/pdf</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'mp3')">
                        <internetMediaType>audio/mp3</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'tif')">
                        <internetMediaType>image/tiff</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'mov')">
                        <internetMediaType>video/mov</internetMediaType>
                    </xsl:when>
                <!-- FORM -->
                    <xsl:otherwise>
                        <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="part">
        <xsl:if test="normalize-space(.)!='' and starts-with(lower-case(normalize-space(.)), 'volume')">
            <part>
                <detail>
                    <number><xsl:value-of select="normalize-space(.)"/></number>
                </detail>
            </part>
        </xsl:if>
    </xsl:template>
  
</xsl:stylesheet>
