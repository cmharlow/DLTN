<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="../coreDCtoMODS.xsl"/>
    <xsl:include href="../!remediation/GettyGenre.xsl"/>
    <xsl:include href="../!remediation/LCSHtopics.xsl"/>
    <xsl:include href="../!remediation/Spatial.xsl"/>
    <xsl:include href="../!thumbnails/ContentDMthumbnailDCtoMODS.xsl"/>
        
    <xsl:template match="dc:contributor">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <name>
                <namePart>
                    <xsl:value-of select="normalize-space(.)"/>
                </namePart>
                <role>
                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">
                        <xsl:text>Contributor</xsl:text>
                    </roleTerm>
                </role> 
            </name>       
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <name>
                <namePart>
                    <xsl:value-of select="normalize-space(.)"/>
                </namePart>
                <role>
                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">
                        <xsl:text>Creator</xsl:text>
                    </roleTerm>
                </role> 
            </name>       
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:publisher">
        <xsl:if test="normalize-space(.)!=''">
            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="recordSource">
        <recordInfo>
            <recordContentSource>Tennessee State Library and Archives</recordContentSource>
            <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
        </recordInfo>
    </xsl:template>
    
    <xsl:template match="dc:relation"> <!-- mix of notes, related item ids, related item URLs, and form/genre terms -->
        <xsl:if test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)),'tennessee state library')">
            <xsl:choose>
                <xsl:when test="starts-with(normalize-space(lower-case(.)), 'http') or starts-with(normalize-space(lower-case(.)), 'ttp') or starts-with(normalize-space(lower-case(.)), 'www')">
                    <relatedItem>
                        <location>
                            <url><xsl:value-of select="normalize-space(.)"/></url>
                        </location>
                    </relatedItem>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'composite')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300134769">composite photographs</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'contact print')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127169">contact prints</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'copy print')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300188795">copy prints</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'photographic print')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127104">photographic prints</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'political cartoon')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300123224">political cartoons</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'printed postcard')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'real photo postcard')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300192703">photographic postcards</genre>
                </xsl:when> 
                <xsl:otherwise>
                    <note><xsl:value-of select="normalize-space(.)"/></note><!-- would like to parse out notes versus related item identifiers, but no easy way to do so. CMH 5/12/2015 -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:relation" mode="form"> <!-- form terms -->
        <xsl:if test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)),'tennessee state library')">
            <xsl:choose>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'composite')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'contact print')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'copy print')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'photographic print')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'political cartoon')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'printed postcard')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'real photo postcard')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:call-template name="LCSHtopic">
                    <xsl:with-param name="term"><xsl:value-of select="replace(., ' -- ', '--')"></xsl:value-of></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'map')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                    <typeOfResource>cartographic</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'manuscripts')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028569">manuscripts (document genre)</genre>
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'audio') or contains(normalize-space(lower-case(.)), 'sound')">
                    <typeOfResource>sound recording</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'object')">
                    <typeOfResource>three dimensional object</typeOfResource>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'video')">
                    <typeOfResource>moving image</typeOfResource>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
