<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:include href="knoxpublicdctomods.xsl"/>
    <xsl:include href="coredctomods.xsl"/>
    <xsl:include href="contentdmthumbnaildctomods.xsl"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
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
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:call-template name="photocollLanguage"/>
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="relatedItem"/>
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:type" mode="genre"/> <!-- genres -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>C.A. Wayland Collection</title>
                </titleInfo>
                <abstract>The C.A. Wayland Stereograph Collection consists of 323 stereograph images, most taken by Columbus Alexander Wayland (December 26, 1868-January 2, 1950), who lived in South Knoxville, Tennessee. The last fifteen images in the collection were ones collected by Mr. Wayland rather than photographed by him. The subjects include Theodore Roosevelt, Alvin York, and President Taft, the 1910 Appalachian Exposition in Knoxville, 1907 Prohibition Parades in Knoxville, Old Gray Cemetery and other Knoxville cemeteries, Knoxville scenes, and photographs taken in Brunswick, Georgia. Mr. Wayland’s occupation was that of a specialty carpenter who created custom staircases in homes for his employer, the D.M. Rose Lumber Company.</abstract>
                <location>
                    <url>http://cdm16311.contentdm.oclc.org/cdm/landingpage/collection/p16311coll1</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordInfo"/> <!-- record info for Knoxville Public Libraries collections -->
        </mods>
    </xsl:template>
    
<!-- Typo Repairs, Static Additions -->
    <xsl:template name="photocollLanguage">
        <language>
            <languageTerm type="code" authority="iso639-2b">zxx</languageTerm>
        </language>
    </xsl:template>
    
</xsl:stylesheet>
