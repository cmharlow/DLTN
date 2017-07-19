<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="knoxpublicdctomods.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date[1]"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:contributor" mode="publisher"/> <!-- publisher parsed from contributor -->
                    <xsl:apply-templates select="dc:creator" mode="publisher"/> <!-- publisher parsed from creator -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form information -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/><!-- thumbnail URL for ContentDM -->
                </location>
            </xsl:if>
            
            <xsl:call-template name="photocollLanguage"/>
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:call-template name="dc:rightsTypoRepair"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="relatedItem"/>
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:type" mode="genre"/> <!-- genres -->
            <xsl:apply-templates select="dc:source"/> <!-- collections -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>The Thompson Photograph Collection</title>
                </titleInfo>
                <abstract>James E. (Jim) Thompson (1881-1976) was one of Knoxville’s pioneer commercial and professional photographers. He captured a rich visual legacy of East Tennessee from 1907 to 1960.  This growing digital collection will eventually contain 10,000 images covering the years from the early 1920s to mid-1930s. The Thompson Photograph Collection includes an estimated 75,000 negatives, providing a rich visual legacy of Knoxville and East Tennessee from 1907 to 1960. Preservation printing of these negatives has been the major focus of the McClung Historical Collection for two decades. Jim Thompson and his younger brother Robin Thompson (1895-1977) were business partners from 1920 to 1926 as Thompson Brothers. Both men were pioneer commercial photographers. By the late 1920s, Jim Thompson’s photographs (Jim Thompson Co.) and those of his brother Robin Thompson (Robin Thompson, Inc.) were appearing in local and national commercial publications.</abstract>
                <location>
                    <url>http://cdm16311.contentdm.oclc.org/cdm/landingpage/collection/p265301coll7</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordInfo"/>
        </mods>
    </xsl:template>
        
<!-- Typo Repairs, Static Additions -->
    <xsl:template name="dc:rightsTypoRepair">
        <accessCondition type='local rights statement'>To use photographs or to order reproductions, contact DigitalCollections@knoxlib.org or phone 865 215-8808. Please refer to Image Number and provide a brief description of the photograph.</accessCondition>
    </xsl:template>
    
    <xsl:template name="photocollLanguage">
        <language>
            <languageTerm type="code" authority="iso639-2b">zxx</languageTerm>
        </language>
    </xsl:template>
        
</xsl:stylesheet>