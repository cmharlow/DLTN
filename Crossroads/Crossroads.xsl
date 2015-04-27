<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns="http://www.loc.gov/mods/v3" version="2.0">
    <xsl:output method="xml"  omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <xsl:apply-templates select="oai_dc:dc" />
    </xsl:template>
    
    <xsl:template match="oai_dc:dc">
        <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd" version="3.5">      
            <xsl:apply-templates select="dc:title"/>
            
            <!-- Some identifiers are dspace pid - actual identifiers - others are the object in context url. 
                this just refers to former; latter is handled in location template -->
            <xsl:apply-templates select="dc:identifier"/>
            
            <xsl:if test="lower-case(normalize-space(dc:creator)) != 'n/a'">
                <xsl:apply-templates select="dc:creator"/>
            </xsl:if>
            <xsl:if test="lower-case(normalize-space(dc:contributor)) != 'n/a'">
                <xsl:apply-templates select="dc:contributor"/>
            </xsl:if>
            
            <xsl:if test="lower-case(normalize-space(dc:date)) != '' or not(contains(lower-case(normalize-space(dc:publisher)),'crossroads to freedom'))">
                <xsl:call-template name="originInfo"/>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/>
            
            <xsl:if test="lower-case(normalize-space(dc:format)) != 'n/a' or lower-case(normalize-space(dc:hasversion)) != 'n/a'">
                <xsl:call-template name="physicalDescription"/>
            </xsl:if>
            
            
            <xsl:apply-templates select="dc:description"/>
            
            <xsl:apply-templates select="dc:spatial"/>
            <xsl:apply-templates select="dc:subject"/>
            <xsl:apply-templates select="dc:temporal"/>
            
            <xsl:apply-templates select="dc:type"/>
            
            <xsl:apply-templates select="dc:medium"/>
            
            <xsl:apply-templates select="dc:rights"/>
            <xsl:if test="lower-case(normalize-space(dc:bibliographiccitation)) != 'n/a'">
                <xsl:apply-templates select="dc:bibliographiccitation"/>
            </xsl:if>
            
            <xsl:apply-templates select="dc:provenance"/>
            <xsl:if test="starts-with(dc:relation, 'rds:')">
                <xsl:apply-templates select="dc:relation"/>
            </xsl:if>
            <xsl:if test="contains(lower-case(dc:source), 'collection') or contains(lower-case(dc:source), 'corp')">
                <xsl:call-template name="Collection"/>
            </xsl:if>
            
            <xsl:if test="contains(lower-case(dc:source), 'archive') or contains(lower-case(dc:source), 'library') or contains(lower-case(dc:source), 'association') or starts-with(lower-case(normalize-space(dc:identifier)), 'http://')">
                <xsl:call-template name="Location"/>
            </xsl:if>
            
            <xsl:apply-templates select="dc:availability"/>
            
            <xsl:call-template name="recordInfo"/>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:availability">
        <extension xmlns:dcterms="http://purl.org/dc/terms/">
            <dcterms:available encoding="edtf">
                <xsl:value-of select="."/>
            </dcterms:available>
        </extension>
    </xsl:template>
    
    <xsl:template match="dc:bibliographiccitation">
        <accessCondition type="use and reproduction">
            <xsl:value-of select="."/>
        </accessCondition>
    </xsl:template>
    
    <xsl:template name="Collection">
        <relatedItem type="host" displayLabel="Collection">
            <title>
                <titleInfo>
                    <xsl:value-of select="."/>
                </titleInfo>
            </title>
        </relatedItem>
    </xsl:template>
    
    <xsl:template name="Location">
        <location>
            <xsl:choose>
                <xsl:when test="contains(lower-case(.), 'archive') or contains(lower-case(.), 'library') or contains(lower-case(.), 'association')">
                    <physicalLocation>
                        <xsl:value-of select="."/>
                    </physicalLocation>
                </xsl:when>
                <xsl:when test="starts-with(lower-case(normalize-space(dc:identifier)), 'http://')">
                    <url access="object in context" usage="primary">
                        <xsl:value-of select="."/>
                    </url>
                </xsl:when>
            </xsl:choose>
        </location>
    </xsl:template>
    
    <xsl:template match="dc:contributor">
        <xsl:choose>
            <xsl:when test="contains(., 'interviewer')">
                <name>
                    <namePart>
                        <xsl:value-of select="replace(., ', interviewer', '')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">
                            <xsl:text>Interviewer</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:when>
            <xsl:when test="contains(., 'digitization')">
                <name>
                    <namePart>
                        <xsl:value-of select="replace(., ', digitization', '')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text">
                            <xsl:text>Digitizer</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:when>
            <xsl:when test="contains(., '(processing)')">
                <name>
                    <namePart>
                        <xsl:value-of select="replace(., ' (processing)', '')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prc">
                            <xsl:text>Process contact</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:when>
            <xsl:when test="contains(., 'processor')">
                <name>
                    <namePart>
                        <xsl:value-of select="replace(., ', processor', '')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prc">
                            <xsl:text>Process contact</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:when>
            <xsl:when test="contains(., ', camera')">
                <name>
                    <namePart>
                        <xsl:value-of select="replace(., ', camera', '')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/vdg">
                            <xsl:text>Videographer</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:when>
            <xsl:when test="contains(., '(camera)')">
                <name>
                    <namePart>
                        <xsl:value-of select="replace(., ' (camera)', '')"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/vdg">
                            <xsl:text>Videographer</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:when>
            <xsl:otherwise>
                <name>
                    <namePart>
                        <xsl:apply-templates/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">
                            <xsl:text>Contributor</xsl:text>
                        </roleTerm>
                    </role> 
                </name>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:template>
    <xsl:template match="dc:creator">
        <xsl:choose>
            <xsl:when test="contains(., 'Crossroad')">
                <name>
                    <namePart>Crossroads to Freedom Digital Archive, Rhodes College</namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prv">
                            <xsl:text>Provider</xsl:text>
                        </roleTerm>
                    </role>
                </name>
            </xsl:when>
            <xsl:when test="contains(., 'nknown')">
                <name>
                    <namePart>Unknown</namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">
                            <xsl:text>Creator</xsl:text>
                        </roleTerm>
                    </role>
                </name> 
            </xsl:when>
            <xsl:otherwise>
                <name>
                    <namePart>
                        <xsl:apply-templates/>
                    </namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">
                            <xsl:text>Creator</xsl:text>
                        </roleTerm>
                    </role>
                </name> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="date">
        <xsl:choose>
            <xsl:when test="contains(., 'n/a')">
            </xsl:when>
            <xsl:when test="contains(., 'year unknown')">
                <dateCreated encoding="edtf" keyDate='yes'>
                    <xsl:value-of select="replace(., 'year unknown', 'uuuu')"/>
                </dateCreated>
            </xsl:when>
            <xsl:when test="contains(., 'unknown day')">
                <dateCreated encoding="edtf" keyDate='yes'>
                    <xsl:value-of select="replace(., 'unknown day', 'uu')"/>
                </dateCreated>
            </xsl:when>
            <xsl:when test="contains(., 'unknown') or contains(., 'Unknown')">
                <dateCreated encoding="edtf" keyDate='yes'>uuuu</dateCreated>
            </xsl:when>
            <xsl:when test="contains(., '[')">
                <dateCreated encoding="edtf" keyDate='yes'>
                    <xsl:value-of select="replace(replace(., '[', ''), ']', '')"/> 
                </dateCreated>
            </xsl:when>
            <xsl:when test="matches(., '^\d{4}$') or matches(., '^\d{4}-\d{2}$') or matches(., '^\d{4}-\d{2}-\d{2}$')">
                <dateCreated encoding="edtf" keyDate='yes'>
                    <xsl:value-of select="."/> 
                </dateCreated>
            </xsl:when>
            <xsl:otherwise>
                <dateCreated>
                    <xsl:apply-templates/>
                </dateCreated>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dc:description">
        <abstract>
            <xsl:apply-templates/>
        </abstract>
    </xsl:template>
    <xsl:template name="physicalDescription">
        <physicalDescription>
            <xsl:choose>
                <xsl:when test="contains(., 'jpg') or contains(., 'jpeg')">
                    <internetMediaType>image/jpeg</internetMediaType>
                </xsl:when>
                <xsl:when test="contains(., 'flash audio')">
                    <internetMediaType>audio/mp4</internetMediaType>
                    <note>flash audio</note>
                </xsl:when>
                <xsl:when test="contains(., 'flash video')">
                    <internetMediaType>video/mp4</internetMediaType>
                    <note>flash video</note>
                </xsl:when>
                <xsl:when test="contains(., 'pdf')">
                    <internetMediaType>application/pdf</internetMediaType>
                </xsl:when>
                <xsl:when test="contains(., 'word')">
                    <internetMediaType>application/msword</internetMediaType>
                </xsl:when>
                <xsl:when test="contains(., 'Born digital') or contains(., 'Born Digital')">
                    <digitalOrigin>born digital</digitalOrigin>
                </xsl:when>
                <xsl:when test="contains(., 'Crossroads Video') or contains(., 'Crossroads video') or contains(., 'CrossroadsVideo')">
                    <digitalOrigin>reformatted digital</digitalOrigin>
                    <note>Crossroads video</note>
                </xsl:when>
                <xsl:when test="contains(., 'CrossroadsText')">
                    <digitalOrigin>reformatted digital</digitalOrigin>
                    <note>Crossroads text</note>
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
        <xsl:if test="starts-with(., 'rds')">
            <identifier type="pid">
                <xsl:value-of select="."/>
            </identifier>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dc:language">
        <language>
            <xsl:choose>
                <xsl:when test="contains(., 'English') or contains(., 'english') or contains(., 'Englsih') or contains(., 'Enlish')">
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
            </xsl:choose>
        </language>
    </xsl:template>
    <xsl:template match="dc:medium">
        <xsl:choose>
            <xsl:when test="contains(lower-case(.), 'application')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027002">application forms</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'audio cassette')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028661">audiocassettes</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'audio')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028633">sound recordings</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'interview')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'biography')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080102">biographies (documents)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'book')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'booklet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311670">booklets</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'business card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026767">business cards</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'certificate')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026841">certificates</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'check')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300191339">checks (bank checks)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'digital image')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300215302">digital images</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'digital video')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300312050">digital moving image formats</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'document')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026030">documents</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'email')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300149026">electronic mail</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'exam')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026936">examinations (documents)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'flier') or contains(lower-case(.), 'flyer')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300224742">fliers (printed matter)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'form')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300049060">forms (documents)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'handbill') or contains(lower-case(.), 'handout')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027033">handbills</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'notes')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'sheet music')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026430">sheet music</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'image')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'label')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028730">labels (identifying artifacts)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'letter')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026879">letters (correspondence)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'balance sheet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027486">balance sheets</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'manual')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026395">manuals (instructional materials)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'map')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'memo')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026906">memorandums</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'newsletter')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026652">newsletters</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'newspaper')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'magnetic tape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028558">magnetic tapes</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'pamphlet') or contains(lower-case(.), 'pamplet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'copy')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300257688">copies (document genres)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'photograph') or contains(lower-case(.), 'phothgraph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'postage')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300037321">postage stamps</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'postcard')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'poster')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'program')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'receipt')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027573">receipts (financial records)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'speech')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026671">speeches (documents)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'sticker')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300207379">stickers</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'tape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300014685">tape (materials)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'text')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'tickets')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300133073">admission tickets</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'video')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028682">video recordings</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'voucher')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027574">vouchers (sales records)</genre>
                <genre><xsl:value-of select="."/></genre>
            </xsl:when>
            <xsl:otherwise>
                <genre><xsl:value-of select="."/></genre>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="originInfo">
        <originInfo>
            <xsl:apply-templates select="date"/>
            <publisher>
                <xsl:value-of select='.'/>
            </publisher>
        </originInfo>
    </xsl:template>
    
    <xsl:template match="dc:provenance">
        <xsl:if test="not(contains(lower-case(.), 'n/a') or contains(lower-case(.), 'born digital'))">
            <relatedItem type="host" displayLabel="Collection">
                <title>
                    <titleInfo>
                        <xsl:value-of select="."/>
                    </titleInfo>
                </title>
            </relatedItem>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="recordInfo">
        <relatedItem type="host" displayLabel="Project">
            <title>
                <titleInfo>Crossroads to Freedom Digital Archive</titleInfo>
                <location>
                    <url>http://www.crossroadstofreedom.org/</url>
                </location>
            </title>
        </relatedItem>
        <recordInfo>
            <recordContentSource>Rhodes College</recordContentSource>
            <recordCreationDate><xsl:value-of select="record/header/datestamp"/></recordCreationDate>
            <recordChangeDate><xsl:value-of select="current-dateTime()"/></recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using DSpace (data dictionary available: https://wiki.lib.utk.edu/display/DPLA/Crossroads+Mapping+Notes.)</recordOrigin>
        </recordInfo>
    </xsl:template>
    <xsl:template match="dc:relation">
        <relatedItem>
            <identfier>
                <xsl:value-of select="."/>
            </identfier>
        </relatedItem>
    </xsl:template>
    <xsl:template match="dc:rights">
        <accessCondition type="use and reproduction">
            <xsl:apply-templates/>
        </accessCondition>
    </xsl:template>

    <xsl:template match="dc:spatial">
        <xsl:if test="not(contains(., '\d+'))">
            <subject>
                <geographic>
                    <xsl:apply-templates/>
                </geographic>
            </subject>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dc:subject">
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
    </xsl:template>
    <xsl:template match="dc:temporal">
        <xsl:choose>
            <xsl:when test="matches(., '^\d{4}$') or matches(., '^\d{4}-\d{2}$') or matches(., '^\d{4}-\d{2}-\d{2}$')">
                <subject>
                    <temporal encoding="edtf">
                        <xsl:apply-templates/>
                    </temporal>
                </subject>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'unknown') or contains(lower-case(.), 'n/a')">
            </xsl:when>
            <xsl:when test="not(contains(., '\d+'))">
                <subject>
                    <geographic>
                        <xsl:apply-templates/>
                    </geographic>
                </subject>
            </xsl:when>
            <xsl:otherwise>
                <subject>
                    <temporal>
                        <xsl:apply-templates/>
                    </temporal>
                </subject>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dc:title">
        <xsl:if test="normalize-space(.)!=''">
            <titleInfo><title><xsl:value-of select="normalize-space(.)"/></title></titleInfo>
        </xsl:if>
    </xsl:template>
    <xsl:template match="dc:type">
        <xsl:choose>
            <xsl:when
                test="string(text()) = 'MovingImage' or string(text()) = 'movingimage' or string(text()) = 'Moving Image' or string(text()) = 'moving image' or string(text()) = 'movingImage'">
                <typeOfResource>moving image</typeOfResource>
            </xsl:when>
            <xsl:when test="string(text()) = 'PhysicalObject' or string(text()) = 'physicalobject' or string(text()) = 'Physical Object' or string(text()) = 'physical object' or string(text()) = 'physicalObject'">
                <typeOfResource>three dimensional object</typeOfResource>
            </xsl:when>
            <xsl:when test="string(text()) = 'Service' or string(text()) = 'service'">
                <typeOfResource>software, multimedia</typeOfResource>
            </xsl:when>
            <xsl:when test="string(text()) = 'Software' or string(text()) = 'software'">
                <typeOfResource>software, multimedia</typeOfResource>
            </xsl:when>
            <xsl:when test="string(text()) = 'Sound' or string(text()) = 'sound'">
                <typeOfResource>sound recording</typeOfResource>
            </xsl:when>
            <xsl:when test="string(text()) = 'StillImage' or string(text()) = 'stillimage' or string(text()) = 'Still Image' or string(text()) = 'still image' or string(text()) = 'stillImage'">
                <typeOfResource>still image</typeOfResource>
            </xsl:when>
            <xsl:when test="string(text()) = 'Text' or string(text()) = 'text'">
                <typeOfResource>text</typeOfResource>
            </xsl:when>
            <xsl:otherwise>
                <genre>
                    <xsl:value-of select="lower-case(.)"/>
                </genre>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
