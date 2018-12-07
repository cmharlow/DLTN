<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="remediationgettygenre.xsl"/>
    <xsl:include href="remediationlcshtopics.xsl"/>
    <xsl:include href="remediationspatial.xsl"/>
    <xsl:include href="coredctomods.xsl"/>
    <xsl:include href="thumbnailscontentdmdctomods.xsl"/>
    
    <xsl:variable name="catalog" select="document('catalogs/tsla_catalog.xml')"/>
        
    <xsl:template match="dc:contributor">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
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
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'  and not(contains(normalize-space(lower-case(.)), 'approximately')) and not(matches(., '^\d+$'))">
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
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher">
        <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'approximately')) and not(contains(normalize-space(lower-case(.)), 'unknown'))">
            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="rightsRepair"> <!-- some elements missing rights statement, which is required. Existing mapped, those without, given generic.-->
        <xsl:choose>
            <xsl:when test="dc:rights">
                <xsl:apply-templates select="dc:rights"/>
            </xsl:when>
            <xsl:otherwise>
                <accessCondition type='local rights statement'>While TSLA houses an item, it does not necessarily hold the copyright on the item, nor may it be able to determine if the item is still protected under current copyright law. Users are solely responsible for determining the existence of such instances and for obtaining any other permissions and paying associated fees that may be necessary for the intended use.</accessCondition>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="recordSource">
        <recordInfo>
            <recordContentSource>Tennessee State Library and Archives</recordContentSource>
            <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/utkdigitalinitiatives/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
        </recordInfo>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:call-template name="LCSHtopic">
                    <xsl:with-param name="term"><xsl:value-of select="replace(replace(replace(.,' - ', '--'), '-- ', '--'), ' -- ', '--')"/></xsl:with-param>
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
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image') or contains(lower-case(.), 'tiff')">
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
