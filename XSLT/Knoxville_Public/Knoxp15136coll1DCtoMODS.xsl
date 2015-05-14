<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:contributor" /> <!-- name/role -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date | dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:contributor" mode="publisher"/> <!-- publisher parsed from contributor -->
                    <xsl:apply-templates select="dc:creator" mode="publisher"/> <!-- publisher parsed from creator -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
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
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:format" mode="relatedItem"/>
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Hugh Tyler Collection</title>
                </titleInfo>
                <abstract>These photographs from Hugh Tyler's album include photos of James Agee and his mother’s family, some of the few surviving photographs from the time immediately after Agee's father’s death. The photograph album has 37 pages and contains mostly family snapshots. Some photographs appear to have been removed from the album prior to its donation, and there are also several loose photographs. All of the photographs of the photographs in the album have been scanned, even those presently unidentified.</abstract>
                <location>
                    <url>http://cdm16311.contentdm.oclc.org/cdm/landingpage/collection/p15136coll1/</url>
                </location>
            </relatedItem>
            <recordInfo>
                <recordContentSource>Knoxville Public Library</recordContentSource>
                <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </languageOfCataloging>
                <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using DSpace (data dictionary available: https://wiki.lib.utk.edu/display/DPLA/Crossroads+Mapping+Notes.)</recordOrigin>
            </recordInfo>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:title">
        <xsl:if test="normalize-space(.)!=''">
            <titleInfo>
                <title><xsl:value-of select="normalize-space(.)"/></title>
            </titleInfo>
        </xsl:if>
    </xsl:template>
    
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
    
    <xsl:template match="dc:date"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='unknown' and normalize-space(lower-case(.))!='uknown'">
                <xsl:choose>
                <!-- DIRECT EDTF MATCHES -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- DATE RANGES -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2} to \d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' to ', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- Match Month YYYY formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^january \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-01')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^february \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-02')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^march \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-03')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^april \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-04')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^may \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-05')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^june \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-06')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^july \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-07')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^august \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-08')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^september \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-09')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^october \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-10')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^november \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-11')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^december \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-12')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- INFERRED -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '\[')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}-\d{2}-\d{2}\]$') or matches(normalize-space(.), '^\[\d{4}-\d{2}\]$') or matches(normalize-space(.), '^\[\d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="translate(normalize-space(.), '\[\]', '')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}\]\?$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="translate(normalize-space(.), '\[\]', '')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                        <!-- Match [Month YYYY] formatting -->
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[january \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-01')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[february \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-02')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[march \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-03')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[april \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-04')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[may \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-05')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[june \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-06')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[july \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-07')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[august \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-08')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[september \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-09')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[october \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-10')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[november \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-11')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[december \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-12')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="inferred"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- QUESTIONABLE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '?')">
                        <dateCreated qualifier="questionable"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <!-- APPROXIMATE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'circa') or contains(normalize-space(lower-case(.)), 'c.') or contains(normalize-space(lower-case(.)), 'ca.')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}$') or matches(normalize-space(.), '^c. \d{4}-\d{2}$') or matches(normalize-space(.), '^c. \d{4}-\d{2}-\d{2}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}-\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),1, 4),'/'), substring(., 6, 8)), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^ca. \d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c.\d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c.', ''), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}s$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(concat(concat(replace(replace(normalize-space(.), 'c. ', ''), 's', ''), '~'), '/'), concat(replace(replace(normalize-space(.), 'c. ', ''), '0s', '9'), '~'))"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="approximate"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:description">
        <xsl:if test="normalize-space(.)!=''">
            <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
        </xsl:if>
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
                        <xsl:when test="matches(., '.+\d.+')">
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
    
    <xsl:template match="dc:identifier">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="starts-with(., 'http://')">
                </xsl:when>
                <xsl:otherwise>
                    <identifier type="local"><xsl:value-of select="normalize-space(.)"/></identifier>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="URL">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:if test="starts-with(., 'http://')">
                <url usage="primary" access="object in context"><xsl:value-of select="normalize-space(.)"/></url>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="locationurl">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'http')"> 
            <!-- CONTENTdm puts the URI in an <identifier> field in the OAI record -->
            <!-- process identifier into CONTENTdm 6.5 thumbnail urls --> 
            <xsl:variable name="contentdmroot" select="substring-before($idvalue,'/cdm/ref/')"/>
            <xsl:variable name="recordinfo" select="substring-after($idvalue,'/cdm/ref/collection/')"/>
            <xsl:variable name="alias" select="substring-before($recordinfo,'/id/')"/>
            <xsl:variable name="pointer" select="substring-after($recordinfo,'/id/')"/>
            <url access="preview"><xsl:value-of select="concat($contentdmroot,'/utils/getthumbnail/collection/',$alias,'/id/',$pointer)"/></url> <!--CONTENTdm thumbnail url-->
            <!-- end CONTENTdm thumbnail url processing -->           
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:for-each select="tokenize(normalize-space(.), ' &amp; ')">
                <xsl:if test="normalize-space(.)!=''">
                    <language>
                        <xsl:choose>
                            <xsl:when test="contains(normalize-space(lower-case(.)), 'english') or contains(normalize-space(lower-case(.)), 'englsih')">
                                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                            </xsl:when>
                            <xsl:when test="contains(normalize-space(lower-case(.)), 'dutch')">
                                <languageTerm type="code" authority="iso639-2b">dut</languageTerm>
                            </xsl:when>
                            <xsl:when test="contains(normalize-space(lower-case(.)), 'french')">
                                <languageTerm type="code" authority="iso639-2b">fre</languageTerm>
                            </xsl:when>
                            <xsl:when test="normalize-space(lower-case(.))='german'">
                                <languageTerm type="code" authority="iso639-2b">deu</languageTerm>
                            </xsl:when>
                            <xsl:when test="normalize-space(lower-case(.))='italian'">
                                <languageTerm type="code" authority="iso639-2b">ita</languageTerm>
                            </xsl:when>
                            <xsl:when test="normalize-space(lower-case(.))='spanish'">
                                <languageTerm type="code" authority="iso639-2b">spa</languageTerm>
                            </xsl:when>
                        </xsl:choose>
                    </language>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:relation">
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
    
    <xsl:template match="dc:rights">
        <xsl:choose>
            <xsl:when test="matches(normalize-space(.),'^Public domain\.$') or matches(normalize-space(.),'^Public Domain$') or matches(normalize-space(.),'^Public Domain\.$')">
                <accessCondition type="use and reproduction">Public domain</accessCondition>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="normalize-space(.)!=''">
                    <accessCondition type="use and reproduction"><xsl:value-of select="normalize-space(.)"/></accessCondition>
                </xsl:if>     
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:source">
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
            <xsl:if test="normalize-space(.)!=''">
                <subject>
                    <topic><xsl:value-of select="normalize-space(.)"/></topic>
                </subject>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'text') or contains(normalize-space(lower-case(.)), 'pdf')">
                        <typeOfResource>text</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'map')">
                        <typeOfResource>cartographic</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'object')">
                        <typeOfResource>three dimensional object </typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'score')">
                        <typeOfResource>notated music</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'sound') or contains(normalize-space(lower-case(.)), 'audio')">
                        <typeOfResource>sound recording</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'video') or contains(lower-case(normalize-space(.)), 'moving image')">
                        <typeOfResource>moving image</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'still image') or contains(normalize-space(lower-case(.)), 'image')">
                        <typeOfResource>still image</typeOfResource>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'collection')">
                        <typeOfResource>mixed material</typeOfResource>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
