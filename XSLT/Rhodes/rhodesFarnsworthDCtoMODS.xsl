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
            
            <originInfo> 
                <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                <xsl:apply-templates select="dc:publisher"/> <!-- publisher NOT digital library -->
            </originInfo>
            
            <physicalDescription>
                <xsl:apply-templates select="dc:format"/> <!-- extent, forms -->
                <xsl:apply-templates select="dc:subject" mode="form"/> <!-- form and extent, note -->
            </physicalDescription>
            
            <location>
                <physicalLocation>Rhodes College</physicalLocation>
                <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
            </location>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- note, primarily season note -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:date" mode="rights"/> <!-- some stray rights statements -->
            <xsl:apply-templates select="dc:subject"/> <!-- all genre/form terms, mapped as such -->
            <xsl:apply-templates select="dc:coverage"/> <!-- temporal and geographic subject info -->
            <xsl:apply-templates select="dc:subject" mode="type"/> <!-- typeOfResource -->
            <xsl:apply-templates select="dc:type"/> <!-- typeOfResource -->
            <xsl:apply-templates select="dc:title" mode="seriesTitle"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Farnsworth Shakespeare Print Collection</title>
                </titleInfo>
                <location>
                    <url>https://dlynx.rhodes.edu/jspui/handle/10267/21536</url>
                </location>
            </relatedItem>
            <recordInfo>
                <recordContentSource>Rhodes College</recordContentSource>
                <xsl:apply-templates select="dc:date" mode="timestamp" /> <!-- Record creation dates mixed in with item creation dates -->
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
    
    <xsl:template match="dc:title" mode="seriesTitle">
        <xsl:choose>
            <xsl:when test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)), 'rhodes college today')">
                <relatedInfo type="preceding">
                    <title>Southwestern Today</title>
                </relatedInfo>
                <relatedInfo type="succeeding">
                    <title>Rhodes</title>
                </relatedInfo>
            </xsl:when>
            <xsl:when test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)), 'rhodes')">
                <relatedInfo type="preceding">
                    <title>Rhodes Today</title>
                </relatedInfo>
            </xsl:when>
            <xsl:when test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)), 'southwestern alumni')">
                <relatedInfo type="succeeding">
                    <title>Southwestern News</title>
                </relatedInfo>
            </xsl:when>
            <xsl:when test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)), 'southwestern news')">
                <relatedInfo type="preceding">
                    <title>Southwestern Alumni</title>
                </relatedInfo>
                <relatedInfo type="succeeding">
                    <title>Southwestern Today</title>
                </relatedInfo>
            </xsl:when>
            <xsl:when test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)), 'southwestern today')">
                <relatedInfo type="preceding">
                    <title>Southwestern News</title>
                </relatedInfo>
                <relatedInfo type="succeeding">
                    <title>Rhodes Today</title>
                </relatedInfo>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:contributor">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'season 10'">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'photographer')">
                <name>
                    <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">
                            <xsl:text>Photographer</xsl:text>
                        </roleTerm>
                    </role>
                </name> 
                </xsl:when>
                <xsl:otherwise>
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
                </xsl:otherwise>
            </xsl:choose>          
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'unknown')">
                    <name>
                        <namePart>Unknown</namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">
                                <xsl:text>Creator</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), ', pinxt.')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', pinxt.', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">
                                <xsl:text>Artist</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'pinxt.')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ' pinxt.', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">
                                <xsl:text>Artist</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'painter')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', painter', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">
                                <xsl:text>Artist</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'sculp. and direxit')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', sculp. and direxit', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">
                                <xsl:text>Sculptor</xsl:text>
                            </roleTerm>
                        </role>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/drt">
                                <xsl:text>Director</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'sculp. and excudit')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', sculp. and excudit.', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">
                                <xsl:text>Sculptor</xsl:text>
                            </roleTerm>
                        </role>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">
                                <xsl:text>Engraver</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), ', sculp')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', sculp', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">
                                <xsl:text>Sculptor</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), '--sculp')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), '--Sculp', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">
                                <xsl:text>Sculptor</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), ',sculp')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ',sculp', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">
                                <xsl:text>Sculptor</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), ', engraver')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', engraver', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">
                                <xsl:text>Engraver</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), ', Engravers')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', Engravers', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">
                                <xsl:text>Engraver</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'direxit')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', Engravers', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/drt">
                                <xsl:text>Director</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'excudit')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', Engravers', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">
                                <xsl:text>Engraver</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'photographer')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">
                                <xsl:text>Photographer</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'del.')">
                    <name>
                        <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">
                                <xsl:text>Photographer</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'printer')">
                    <name>
                        <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prt">
                                <xsl:text>Printer</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'del.')">
                    <name>
                        <namePart><xsl:value-of select="normalize-space(replace(., ', del.', ''))"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dln">
                                <xsl:text>Delineator</xsl:text>
                            </roleTerm>
                        </role>
                    </name> 
                </xsl:when>
                <xsl:otherwise>
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
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>                
    </xsl:template>
    
    <xsl:template match="dc:date"> 
        <xsl:if test="normalize-space(.)!='' and not(matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}T.'))">
            <xsl:choose>
                <xsl:when test="contains(lower-case(.), 'unknown') or contains(lower-case(.), 'undated')">
                    <dateCreated encoding="edtf" keyDate="yes">uuuu</dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <!--here be dragons, dude-->
                <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:date" mode="timestamp">
        <xsl:if test="matches(normalize-space(.),'^\d{4}-\d{2}-\d{2}T.')">
            <recordCreationDate><xsl:value-of select="normalize-space(.)"/></recordCreationDate>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:description">
        <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'born digital'))">
            <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:format"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:if test="normalize-space(.)!=''">
            <xsl:for-each select="tokenize(normalize-space(lower-case(.)), 'hxw')">
                <xsl:if test="normalize-space(.)!=','">
                    <xsl:choose>
                        <xsl:when test="contains(normalize-space(.), 'wxh')">
                            <xsl:for-each select="tokenize(normalize-space(lower-case(.)), 'wxh')">
                                <xsl:if test="contains(., 'engraving')">
                                    <form>engraving</form>
                                </xsl:if>
                                <xsl:if test="contains(., 'print')">
                                    <form>print</form>
                                </xsl:if>
                                <xsl:if test="contains(., 'daguerreotye')">
                                    <form>daguerreotye</form>
                                </xsl:if>
                                <xsl:if test="matches(., '\d+')">
                                    <extent><xsl:value-of select="normalize-space(.)"/></extent>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when  test="contains(., 'engraving')">
                            <form>engraving</form>
                        </xsl:when>
                        <xsl:when test="contains(., 'print')">
                            <form>print</form>
                        </xsl:when>
                        <xsl:when test="contains(., 'daguerreotye')">
                            <form>daguerreotye</form>
                        </xsl:when>
                        <xsl:when test="matches(., '\d+')">
                            <extent><xsl:value-of select="normalize-space(.)"/></extent>
                        </xsl:when>
                        <xsl:when test="matches(., '\d+')">
                            <extent><xsl:value-of select="normalize-space(.)"/></extent>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
            <note><xsl:value-of select="normalize-space(.)"/></note>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="starts-with(., 'http://')">
                    <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
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
    
    <xsl:template match="dc:language">
        <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='other'">
            <language>
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space(lower-case(.)), 'en')">
                        <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    </xsl:when>
                    <xsl:otherwise>
                        <languageTerm type="text" authority="iso639-2b"><xsl:value-of select="normalize-space(.)"/></languageTerm>
                    </xsl:otherwise>
                </xsl:choose>
            </language>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> 
        <xsl:if test="normalize-space(.)!='' and not(contains(lower-case(normalize-space(dc:publisher)),'dc.publisher')) and lower-case(normalize-space(dc:publisher))!='na' and lower-case(normalize-space(dc:publisher))!='n. a.'">
            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
        </xsl:if>            
    </xsl:template>
    
    <xsl:template match="dc:relation">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                    <xsl:when test="contains(.,'http')"> 
                        <relatedItem>
                            <location>
                                <url><xsl:value-of select="normalize-space(.)"/></url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'collection')">
                        <relatedItem type='host' displayLabel='Collection'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                        </relatedItem>
                    </xsl:when>
                    <xsl:otherwise>
                        <relatedItem>
                            <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
                        </relatedItem>
                    </xsl:otherwise>
                </xsl:choose>
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
    
    <xsl:template match="dc:subject">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'books')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'prints')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300041273">prints (visual works)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'daguerreotype')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127181">daguerreotypes (photographs)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'engraving')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300041340">engravings (prints)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'maps')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'miniatures')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033936">miniatures (paintings)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'newspapers')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'periodicals')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026657">periodicals</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'playbill')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027216">playbills</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'portraits')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015637">portraits</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'posters')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'poster')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'program')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'letter')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026879">letters (correspondence)</genre>
                </xsl:when>
                <xsl:otherwise>
                    <subject>
                        <topic><xsl:value-of select="normalize-space(.)"/></topic>
                    </subject>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:subject" mode="form">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:if test="contains(normalize-space(lower-case(.)), 'image') or contains(normalize-space(lower-case(.)), 'print') or contains(normalize-space(lower-case(.)), 'daguerreotype') or contains(normalize-space(lower-case(.)), 'letter')">
                <form>normalize-space(lower-case(.)</form>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:subject" mode="type">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'other')">
                    <!-- do not map -->
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
