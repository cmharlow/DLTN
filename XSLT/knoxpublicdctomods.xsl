<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="gettygenre.xsl"/>
    <xsl:include href="lcshtopics.xsl"/>
    
    <!-- OAI-DC to MODS Knoxville Public Institution-Level Transformations. Includes the following templates:
        dc:contributor
        dc:contributor mode=publisher
        dc:creator
        dc:creator mode=publisher
        dc:format
        dc:format mode=relatedItem
        dc:publisher (left at institution level to remove/block institution that digitized as publisher)
        recordInfo (static value for all Knoxville Public Library collections)
        dc:relation
        dc:source
        dc:subject
        dc:type
        dc:type mode=genre
        dc:type mode=form
    -->
    
    <xsl:template match="dc:contributor">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(.)!='unknown'">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(.), 'Importer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Importer, New York.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Importer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Architect')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Architects', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Designed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Designed by ', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dsr">Designer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Lith.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Lith. &amp; print. by ', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ltg">Lithographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prt">Printer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="starts-with(lower-case(normalize-space(.)), 'copied by')">
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'mm-\d{4}-\d{3}')">
                        <!-- stray dates? skipped -->
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'publisher')">
                        <!-- mapped to publisher in contributor mode:publisher -->
                    </xsl:when>
                    <xsl:otherwise>
                        <name>
                            <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>  
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:contributor" mode="publisher">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(lower-case(.)), 'publisher')">
                    <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'unknown')) and not(contains(normalize-space(lower-case(.)), 'published by'))">
                <xsl:for-each select="tokenize(normalize-space(translate(., '\(\)\[\]_', '')), '/')">
                    <xsl:choose>
                        <xsl:when test="contains(normalize-space(.), 'Architects')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Architects', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Architect')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Architect', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Artist')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Artist', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">Artist</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Drawn by')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), 'Drawn by ', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">Artist</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Editor')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Editor', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Edited by')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), 'Edited by ', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'leading Out-Door Photographer')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ' leading Out-Door Photographer', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Out-Door Photographer')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), 'Out-Door Photographer', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Traveling Photographers')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Traveling Photographers', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Photograph by')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), 'Photograph by ', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Photographer')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Photographer', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Photographer')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), ', Photographer.', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Taken by')">
                            <name>
                                <namePart><xsl:value-of select="replace(normalize-space(.), 'Taken by ', '')"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                </role> 
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Charles Scribner')">
                            <!-- moved to publisher -->
                        </xsl:when>
                        <xsl:when test="matches(normalize-space(.), '\D+ \d{2}, \d{4}')">
                            <!-- stray dates, skipped -->
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'Southern Review') or contains(normalize-space(.), 'Journal')">
                            <relatedItem type="Host">
                                <titleInfo>
                                    <title><xsl:value-of select="normalize-space(.)"/></title>
                                </titleInfo>
                            </relatedItem>
                        </xsl:when>
                        <xsl:otherwise>
                            <name>
                                <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                                <role>
                                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                                </role> 
                            </name> 
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>  
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator" mode="publisher">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(.), 'Published by') or contains(normalize-space(.), 'Charles Scribner')">
                    <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ',')">
                <xsl:if test="normalize-space(.)!=''">
                    <xsl:choose>
                        <xsl:when test="contains(., 'jpeg') or contains(., 'jpg')">
                            <internetMediaType>image/jpeg</internetMediaType>
                        </xsl:when>
                        <xsl:when test="contains(., 'tiff')">
                            <internetMediaType>image/tiff</internetMediaType>
                        </xsl:when>
                        <xsl:when test="matches(., '.+\d.+') and not(contains(lower-case(.), 'telegram'))">
                            <extent><xsl:value-of select="normalize-space(.)"/></extent>
                        </xsl:when>
                        <xsl:when test="contains(., 'collection') or contains(., 'papers')">
                            <!-- stray collection terms mapped in format mode:relatedItem -->
                        </xsl:when>
                        <xsl:otherwise>
                            <note><xsl:value-of select="."/></note>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="relatedItem">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(., 'Collection') or contains(., 'Papers')">
                    <relatedItem type="host" displayLabel="Collection">
                        <titleInfo>
                            <title><xsl:value-of select="normalize-space(.)"/></title>
                        </titleInfo>
                    </relatedItem>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="recordInfo">
        <recordInfo>
            <recordContentSource>Knoxville Public Library</recordContentSource>
            <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
        </recordInfo>
    </xsl:template>
    
    <xsl:template match="dc:relation|dc:source">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <relatedItem type='host' displayLabel='Collection'>
                    <titleInfo>
                        <title><xsl:value-of select="normalize-space(.)"/></title>
                    </titleInfo>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:for-each select="tokenize(normalize-space(.), ',')">
                <xsl:if test="normalize-space(.)!=''">
                    <xsl:call-template name="LCSHtopic">
                        <xsl:with-param name="term"><xsl:value-of select="lower-case(normalize-space(.))"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(., 'text') or contains(., 'pdf') or contains(., 'advertis') 
                        or contains(., 'application') or contains(., 'article') or contains(., 'biography')
                        or contains(., 'book') or contains(., 'broadside') or contains(., 'card') or contains(., 'catalog')
                        or contains(., 'clipping') or contains(., 'correspondence') or contains(., 'document')
                        or contains(., 'folio') or contains(., 'interview') or contains(., 'letterhead')
                        or contains(., 'magazine') or contains(., 'manuscript') or contains(., 'newsletter')
                        or contains(., 'newspaper') or contains(., 'pamphlet') or contains(., 'periodical')
                        or contains(., 'page') or contains(., 'program') or contains(., 'report') or contains(., 'scrapbook')
                        or contains(., 'typescript')">
                        <typeOfResource>text</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(., 'map')">
                        <typeOfResource>cartographic</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(., 'object') or contains(., 'artifact') or contains(., 'case') or contains(., 'envelope')
                        or contains(., 'ephemera') or contains(., 'slide') or contains(., 'medallion') or contains(., 'pin')">
                        <typeOfResource>three dimensional object </typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(., 'score') or contains(., 'sheet music')">
                        <typeOfResource>notated music</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(., 'sound') or contains(., 'audio')">
                        <typeOfResource>sound recording</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(., 'video') or contains(., 'moving image')">
                        <typeOfResource>moving image</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(., 'image') or contains(., 'photograph') or contains(., 'ambrotype') or contains(., 'drawing')
                        or contains(., 'cityscape') or contains(., 'etching') or contains(., 'portrait') or contains(., 'illustration')
                        or contains(., 'lithograph') or contains(., 'miniature') or contains(., 'painting') or contains(., 'rendering')
                        or contains(., 'sign') or contains(., 'sketchbook') or contains(., 'specification') or contains(., 'stereograph') 
                        or contains(., 'tintype') or contains(., 'view')"> 
                        <typeOfResource>still image</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'collection')">
                        <typeOfResource>mixed material</typeOfResource>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type" mode="form">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <form><xsl:value-of select="normalize-space(.)"/></form>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type" mode="genre">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:call-template name="AATgenre">
                    <xsl:with-param name="term"><xsl:value-of select="lower-case(normalize-space(.))"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
