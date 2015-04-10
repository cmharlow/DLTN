<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="oai_dc dc"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:include href="http://www.loc.gov/standards/mods/inc/dcmiType.xsl"/>
    <xsl:include href="http://www.loc.gov/standards/mods/inc/mimeType.xsl"/>
    <xsl:include href="http://www.loc.gov/standards/mods/inc/csdgm.xsl"/>
    <xsl:include href="http://www.loc.gov/standards/mods/inc/forms.xsl"/>
    <xsl:include href="http://www.loc.gov/standards/mods/inc/iso3166-1.xsl"/>
    <xsl:include href="http://www.loc.gov/standards/mods/inc/iso639-2.xsl"/>
    <xsl:template match="/">
        <xsl:if test="oai_dc:dc">
            <xsl:if test="/oai_dc:dc/"
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="oai_dc:dc">
        <mods xmlns="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.5"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:call-template name="dcMain"/>
        </mods>
    </xsl:template>
    <xsl:template name="dcMain">
        <xsl:apply-templates select="dc:title"/>
        <xsl:apply-templates select="dc:creator"/>
        <xsl:apply-templates select="dc:contributor"/>
        <xsl:apply-templates select="dc:type"/>
        <xsl:apply-templates select="dc:subject | dc:coverage"/>
        <xsl:apply-templates select="dc:description"/>
        <xsl:apply-templates select="dc:publisher"/>
        <xsl:apply-templates select="dc:date"/>
        <xsl:apply-templates select="dc:format"/>
        <xsl:apply-templates select="dc:identifier"/>
        <xsl:apply-templates select="dc:source | dc:relation"/>
        <xsl:apply-templates select="dc:language"/>
        <xsl:apply-templates select="dc:rights"/>
    </xsl:template>
    <xsl:template match="dc:title">
        <titleInfo>
            <title>
                <xsl:apply-templates/>
            </title>
        </titleInfo>
    </xsl:template>
    <xsl:template match="dc:creator">
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm type="text">
                    <xsl:text>Creator</xsl:text>
                </roleTerm>
            </role>
        </name>
    </xsl:template>
    <xsl:template match="dc:subject">
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
    </xsl:template>
    <xsl:template match="dc:description">
        <abstract>
            <xsl:apply-templates/>
        </abstract>
        <note>
            <xsl:apply-templates/>
        </note>
    </xsl:template>
    <xsl:template match="dc:publisher">
        <originInfo>
            <publisher>
                <xsl:apply-templates/>
            </publisher>
        </originInfo>
    </xsl:template>
    <xsl:template match="dc:contributor">
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm type="text">
                    <xsl:text>Contributor</xsl:text>
                </roleTerm>
            </role> 
        </name>
    </xsl:template>
    <xsl:template match="dc:date">
        <originInfo>
            <dateIssued>
                <xsl:apply-templates/>
            </dateIssued>
            <dateCreated>
                <xsl:apply-templates/>
            </dateCreated>
            <dateCaptured>
                <xsl:apply-templates/>
            </dateCaptured>
            <dateOther>
                <xsl:apply-templates/>
            </dateOther>
        </originInfo>
    </xsl:template>
    <xsl:template match="dc:type">
        <xsl:variable name="collection">
            <xsl:if
                test="../dc:type[string(text()) = 'collection' or string(text()) = 'Collection']"
                >true</xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains(text(), 'Collection') or contains(text(), 'collection')">
                <genre authority="dct">
                    <xsl:text>collection</xsl:text>
                </genre>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string(text()) = 'Dataset' or string(text()) = 'dataset'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>database</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Event' or string(text()) = 'event'">
                        <genre authority="dct">
                            <xsl:text>event</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Image' or string(text()) = 'image'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>still image</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>image</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when
                        test="string(text()) = 'InteractiveResource' or string(text()) = 'interactiveresource' or string(text()) = 'Interactive Resource' or string(text()) = 'interactive resource' or string(text()) = 'interactiveResource'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>interactive resource</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when
                        test="string(text()) = 'MovingImage' or string(text()) = 'movingimage' or string(text()) = 'Moving Image' or string(text()) = 'moving image' or string(text()) = 'movingImage'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>moving image</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>moving image</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when
                        test="string(text()) = 'PhysicalObject' or string(text()) = 'physicalobject' or string(text()) = 'Physical Object' or string(text()) = 'physical object' or string(text()) = 'physicalObject'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>three dimensional object</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>physical object</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Service' or string(text()) = 'service'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>online system or service</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Software' or string(text()) = 'software'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>software</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Sound' or string(text()) = 'sound'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>sound recording</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>sound</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when
                        test="string(text()) = 'StillImage' or string(text()) = 'stillimage' or string(text()) = 'Still Image' or string(text()) = 'still image' or string(text()) = 'stillImage'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>still image</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>still image</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Text' or string(text()) = 'text'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>text</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>text</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(string($types) = text())">
                            <!--
<typeOfResource>
                                <xsl:text>mixed material</xsl:text>
                                </typeOfResource>
-->
                            <genre>
                                <xsl:value-of select="lower-case(.)"/>
                            </genre>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dc:format">
        <physicalDescription>
            <xsl:choose>
                <xsl:when test="contains(text(), '/')">
                    <xsl:variable name="mime" select="substring-before(text(), '/')"/>
                    <xsl:choose>
                        <xsl:when test="contains($mimeTypeDirectories, $mime)">
                            <internetMediaType>
                                <xsl:apply-templates/>
                            </internetMediaType>
                        </xsl:when>
                        <xsl:otherwise>
                            <note>
                                <xsl:apply-templates/>
                            </note>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!--
 2.0: added regex to test for numeric data at the begining of the element 
-->
                <xsl:when test="matches(.,'^\d')">
                    <extent>
                        <xsl:apply-templates/>
                    </extent>
                </xsl:when>
                <xsl:when test="contains($forms, text())">
                    <form>
                        <xsl:apply-templates/>
                    </form>
                </xsl:when>
                <xsl:otherwise>
                    <note>
                        <xsl:apply-templates/>
                    </note>
                </xsl:otherwise>
            </xsl:choose>
        </physicalDescription>
    </xsl:template>
    <xsl:template match="dc:identifier">
        <xsl:if test="starts-with(text(), 'http://')">
            <location>
                <url>
                    <xsl:value-of select="."/>
                </url>
            </location>
        </xsl:if>
        <xsl:variable name="iso-3166Check">
            <xsl:value-of select="substring(text(), 1, 2)"/>
        </xsl:variable>
        <identifier>
            <xsl:attribute name="type">
                <xsl:choose>
                    <!--  handled by location/url  -->
                    <xsl:when
                        test="starts-with(text(), 'http://') and (not(contains(text(), $handleServer) or not(contains(substring-after(text(), 'http://'), 'hdl'))))">
                        <xsl:text>uri</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(text(),'urn:hdl') or starts-with(text(),'hdl') or starts-with(text(),'http://hdl.')">
                        <xsl:text>hdl</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'doi')">
                        <xsl:text>doi</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'ark')">
                        <xsl:text>ark</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(text(), 'purl')">
                        <xsl:text>purl</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'tag')">
                        <xsl:text>tag</xsl:text>
                    </xsl:when>
                    <!--
NOTE:  will need to update for ISBN 13 as of January 1, 2007, see XSL tool at http://isbntools.com/ 
-->
                    <xsl:when
                        test="(starts-with(text(), 'ISBN') or starts-with(text(), 'isbn')) or ((string-length(text()) = 13) and contains(text(), '-') and (starts-with(text(), '0') or starts-with(text(), '1'))) or ((string-length(text()) = 10) and (starts-with(text(), '0') or starts-with(text(), '1')))">
                        <xsl:text>isbn</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(starts-with(text(), 'ISRC') or starts-with(text(), 'isrc')) or ((string-length(text()) = 12) and (contains($iso3166-1, $iso-3166Check))) or ((string-length(text()) = 15) and (contains(text(), '-') or contains(text(), '/')) and contains($iso3166-1, $iso-3166Check))">
                        <xsl:text>isrc</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(starts-with(text(), 'ISMN') or starts-with(text(), 'ismn')) or starts-with(text(), 'M') and ((string-length(text()) = 11) and contains(text(), '-') or string-length(text()) = 9)">
                        <xsl:text>ismn</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(starts-with(text(), 'ISSN') or starts-with(text(), 'issn')) or ((string-length(text()) = 9) and contains(text(), '-') or string-length(text()) = 8)">
                        <xsl:text>issn</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'ISTC') or starts-with(text(), 'istc')">
                        <xsl:text>istc</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(starts-with(text(), 'UPC') or starts-with(text(), 'upc')) or (string-length(text()) = 12 and not(contains(text(), ' ')) and not(contains($iso3166-1, $iso-3166Check)))">
                        <xsl:text>upc</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="(starts-with(text(), 'SICI') or starts-with(text(), 'sici')) or ((starts-with(text(), '0') or starts-with(text(), '1')) and (contains(text(), ';') and contains(text(), '(') and contains(text(), ')') and contains(text(), '&gt;') and contains(text(), '&lt;')))">
                        <xsl:text>sici</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'LCCN') or starts-with(text(), 'lccn')">
                        <!--
 probably can't do this quickly or easily without regexes and XSL 2.0 
-->
                        <xsl:text>lccn</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>local</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when
                    test="starts-with(text(),'urn:hdl') or starts-with(text(),'hdl') or starts-with(text(),$handleServer)">
                    <xsl:value-of select="concat('hdl:',substring-after(text(),$handleServer))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </identifier>
    </xsl:template>
    <xsl:template match="dc:source">
        <relatedItem type="original">
            <xsl:choose>
                <xsl:when test="starts-with(normalize-space(.),'http://')">
                    <location>
                        <url>
                            <xsl:apply-templates/>
                        </url>
                    </location>
                    <identifier type="uri">
                        <xsl:apply-templates/>
                    </identifier>
                </xsl:when>
                <xsl:otherwise>
                    <titleInfo>
                        <title>
                            <xsl:apply-templates/>
                        </title>
                    </titleInfo>
                </xsl:otherwise>
            </xsl:choose>
        </relatedItem>
    </xsl:template>
    <xsl:template match="dc:language">
        <language>
            <xsl:choose>
                <xsl:when test="string-length(text()) = 3 and contains($iso639-2, text())">
                    <languageTerm type="code">
                        <xsl:apply-templates/>
                    </languageTerm>
                </xsl:when>
                <xsl:otherwise>
                    <languageTerm type="text">
                        <xsl:apply-templates/>
                    </languageTerm>
                </xsl:otherwise>
            </xsl:choose>
        </language>
    </xsl:template>
    <xsl:template match="dc:relation">
        <relatedItem>
            <xsl:choose>
                <xsl:when test="starts-with(text(), 'http://')">
                    <location>
                        <url>
                            <xsl:value-of select="."/>
                        </url>
                    </location>
                    <identifier type="uri">
                        <xsl:apply-templates/>
                    </identifier>
                </xsl:when>
                <xsl:otherwise>
                    <titleInfo>
                        <title>
                            <xsl:apply-templates/>
                        </title>
                    </titleInfo>
                </xsl:otherwise>
            </xsl:choose>
        </relatedItem>
    </xsl:template>
    <xsl:template match="dc:coverage">
        <xsl:choose>
            <xsl:when
                test="contains(text(), '°') or contains(text(), 'geo:lat') or contains(text(), 'geo:lon') or contains(text(), ' N ') or contains(text(), ' S ') or contains(text(), ' E ') or contains(text(), ' W ')">
                <!--
 predicting minutes and seconds with ' or " might break if quotes used for other purposes exist in the text node 
-->
                <subject>
                    <cartographics>
                        <coordinates>
                            <xsl:apply-templates/>
                        </coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when
                test="contains(text(), ':') and starts-with(text(), '1') and matches(substring-after(text(), ':'),'^\d')">
                <subject>
                    <cartographics>
                        <scale>
                            <xsl:apply-templates/>
                        </scale>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="starts-with(.,'Scale')">
                <subject>
                    <cartographics>
                        <scale>
                            <xsl:apply-templates/>
                        </scale>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="contains($projections, text())">
                <subject>
                    <cartographics>
                        <projection>
                            <xsl:apply-templates/>
                        </projection>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when
                test="string-length(.) >= 3 and (matches(.,'^\d') or starts-with(text(), '-') or contains(.,'AD') or contains(.,'BC')) and not(contains(.,':'))">
                <subject>
                    <temporal>
                        <xsl:apply-templates/>
                    </temporal>
                </subject>
            </xsl:when>
            <xsl:otherwise>
                <subject>
                    <geographic>
                        <xsl:apply-templates/>
                    </geographic>
                </subject>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dc:rights">
        <accessCondition>
            <xsl:apply-templates/>
        </accessCondition>
    </xsl:template>
</xsl:stylesheet>
