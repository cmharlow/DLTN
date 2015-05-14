<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
        
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" version="3.5" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title -->
            
            <xsl:apply-templates select="dc:creator"/> <!-- name -->
            <xsl:apply-templates select="dc:contributor"/> <!-- name -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- publisher NOT digital library -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:medium|dc:format|dc:hasversion|dc:provenance">
                <physicalDescription>
                    <xsl:apply-templates select="dc:medium" mode="form"/> <!-- form -->
                    <xsl:apply-templates select="dc:format" /> <!-- internetMediaType -->
                    <xsl:apply-templates select="dc:hasversion" /> <!-- digitalOrigin -->
                    <xsl:apply-templates select="dc:provenance" mode="digitalOrigin"/> <!-- digitalOrigin sometimes -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:source|dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:source" mode="physicalLocation"/> <!-- repository -->
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates> <!-- preview -->
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:medium" /> <!-- genre -->
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:bibliographiccitation"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject" /> <!-- subject/topical -->
            <xsl:apply-templates select="dc:spatial" /> <!-- subject/geographic-->
            <xsl:apply-templates select="dc:temporal" /> <!-- subject/temporal-->
            <xsl:apply-templates select="dc:availability"/> <!-- extension -->
            <xsl:apply-templates select="dc:type"/> <!-- typeOfResource -->
            <xsl:apply-templates select="dc:relation" /> <!-- Related Items -->
            <xsl:apply-templates select="dc:provenance" /> <!-- Related Items mostly -->
            <xsl:apply-templates select="dc:source" /> <!-- Related Items sometimes -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Crossroads to Freedom Digital Archive</title>
                </titleInfo>
                <location>
                    <url>http://www.crossroadstofreedom.org/</url>
                </location>
            </relatedItem>
            <recordInfo>
                <recordContentSource>Rhodes College. Crossroads to Freedom Digital Archive</recordContentSource>
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
    
    <xsl:template match="dc:availability">
        <extension xmlns:dcterms="http://purl.org/dc/terms/">
            <dcterms:available encoding="edtf"><xsl:value-of select="."/></dcterms:available>
        </extension>
    </xsl:template>
    
    <xsl:template match="dc:bibliographiccitation">
        <xsl:if test="lower-case(normalize-space(.)) != 'n/a'">
            <accessCondition type="use and reproduction"><xsl:value-of select="."/></accessCondition>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:contributor">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <xsl:choose>
                <xsl:when test="contains(., 'interviewer')">
                    <name>
                        <namePart><xsl:value-of select="replace(., ', interviewer', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr"><xsl:text>Interviewer</xsl:text></roleTerm>
                        </role> 
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:when>
                <xsl:when test="contains(., 'digitization')">
                    <name>
                        <namePart><xsl:value-of select="replace(., ', digitization', '')"/></namePart>
                        <role>
                            <roleTerm type="text"><xsl:text>Digitizer</xsl:text></roleTerm>
                        </role> 
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:when>
                <xsl:when test="contains(., '(processing)')">
                    <name>
                        <namePart>
                            <xsl:value-of select="replace(., ' (processing)', '')"/>
                        </namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prc"><xsl:text>Process contact</xsl:text></roleTerm>
                        </role> 
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:when>
                <xsl:when test="contains(., 'processor')">
                    <name>
                        <namePart><xsl:value-of select="replace(., ', processor', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prc"><xsl:text>Process contact</xsl:text></roleTerm>
                        </role> 
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:when>
                <xsl:when test="contains(., ', camera')">
                    <name>
                        <namePart><xsl:value-of select="replace(., ', camera', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/vdg"><xsl:text>Videographer</xsl:text></roleTerm>
                        </role> 
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:when>
                <xsl:when test="contains(., '(camera)')">
                    <name>
                        <namePart><xsl:value-of select="replace(., ' (camera)', '')"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/vdg"><xsl:text>Videographer</xsl:text></roleTerm>
                        </role> 
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:when>
                <xsl:otherwise>
                    <name>
                        <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb"><xsl:text>Contributor</xsl:text></roleTerm>
                        </role> 
                    </name>
                </xsl:otherwise>
            </xsl:choose>          
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <!-- check to see if there are any numbers in this coverage value -->
                <xsl:when test='matches(.,"\d+")'>
                    <xsl:choose>
                        <!-- if numbers follow a coordinate pattern, it's probably geo data - which should go in cartographics/coordinates child element -->
                        <xsl:when test='matches(.,"\d+\.\d+")'>
                            <subject>
                                <cartographics>
                                    <coordinates><xsl:value-of select="normalize-space(.)"/></coordinates>
                                </cartographics>
                            </subject>
                        </xsl:when>
                        <!-- if there's no coordinate pattern, it's probably temporal data; put it in temporal -->
                        <xsl:otherwise>
                            <subject>
                                <temporal><xsl:value-of select="normalize-space(.)"/></temporal>
                            </subject>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- if there are no numbers, it's probably geo data as text --> 
                <xsl:otherwise>
                    <subject>
                        <geographic><xsl:value-of select="normalize-space(.)"/></geographic>
                    </subject>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template> 
    
    <xsl:template match="dc:creator">
        <xsl:variable name="creatorvalue" select="normalize-space(.)"/>
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <xsl:choose>
                <xsl:when test="contains(., 'Crossroad')">
                    <name>
                        <namePart>Rhodes College. Crossroads to Freedom Digital Archive</namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prv"><xsl:text>Provider</xsl:text></roleTerm>
                        </role>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre"><xsl:text>Creator</xsl:text></roleTerm>
                        </role>
                    </name>
                </xsl:when>
                <xsl:when test="contains(., 'nknown')">
                </xsl:when>
                <xsl:otherwise>
                    <name>
                        <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                        <role>
                            <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre"><xsl:text>Creator</xsl:text></roleTerm>
                        </role>
                    </name> 
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>          
    </xsl:template>
    
    <xsl:template match="dc:date"> <!-- needs further work to better handle date qualifiers, which aren't used at rhodes -->
        <xsl:variable name="datevalue" select="normalize-space(.)"/>
        <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
            <xsl:choose>
                <xsl:when test="starts-with(., 'year unknown')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(lower-case(.), 'year unknown', 'uuuu')"/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="starts-with(lower-case(.), 'xxxx')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(lower-case(.), 'xxxx', 'uuuu')"/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="ends-with(., 'unknown day')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(lower-case(.), 'unknown day', 'uu')"/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="contains(lower-case(.), 'unknown') or contains(lower-case(.), 'undated')">
                    <dateCreated encoding="edtf" keyDate="yes">uuuu</dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="contains(., '[')">
                    <dateCreated encoding="edtf" keyDate="yes" qualifier="inferred"><xsl:value-of select="substring(., 2, 5)"/> </dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <!--here be dragons, dude-->
                <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/> </dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/> </dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}$')">
                    <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat('uuuu-', normalize-space(.))"/> </dateCreated>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:description">
        <xsl:if test="normalize-space(.)!=''">
            <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:format"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:if test="normalize-space(.)!=''">
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
                    <note>PDF</note>
                </xsl:when>
                <xsl:when test="contains(., 'word')">
                    <internetMediaType>application/msword</internetMediaType>
                    <note>Microsoft Word Document</note>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:hasversion"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:if test="normalize-space(lower-case(.)) != 'n/a' and normalize-space(lower-case(.)) != ''">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'born digital')">
                    <digitalOrigin>born digital</digitalOrigin>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'crossroads video') or contains(normalize-space(lower-case(.)), 'crossroadsvideo')">
                    <digitalOrigin>reformatted digital</digitalOrigin>
                    <note>Crossroads video</note>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'crossroadstext') or contains(normalize-space(lower-case(.)), 'crossroads text')">
                    <digitalOrigin>reformatted digital</digitalOrigin>
                    <note>Crossroads text</note>
                </xsl:when>
                <xsl:otherwise>
                    <note>
                        <xsl:value-of select="normalize-space(.)"/>
                    </note>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="starts-with(., 'rds')">
                    <identifier type="pid"><xsl:value-of select="normalize-space(.)"/></identifier>
                </xsl:when>
                <xsl:when test="starts-with(., 'http://')">
                    <!-- skip, will be handled in identifier mode:URL -->
                </xsl:when>
                <xsl:otherwise>
                    <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="URL">
        <xsl:if test="normalize-space(.)!='' and starts-with(., 'http://')">
            <url usage="primary display" access="object in context"><xsl:value-of select="normalize-space(.)"/></url>
        </xsl:if>
    </xsl:template>
    
    <!-- Crossroads Thumbnails-->
    
    <xsl:template match="dc:identifier" mode="locationurl">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'rds:')"> 
            <!-- Crossroads Fedora puts the PID in an <identifier> field in the OAI record --><!-- process Fedora thumbnail urls -->           
            <xsl:variable name="PID" select="substring-after($idvalue,'rds:')"/>
            <url access="preview"><xsl:value-of select="concat('http://crossroads.rhodes.edu:9090/fedora/get/rds:',$PID,'/thumbnail_100x75.jpg')"/></url> <!--CONTENTdm thumbnail url-->
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <xsl:if test="normalize-space(.)!=''">
            <language>
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'english') or contains(normalize-space(lower-case(.)), 'englsih') or contains(normalize-space(lower-case(.)), 'enlish')">
                        <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                    </xsl:when>
                    <xsl:otherwise>
                        <languageTerm type="text"><xsl:value-of select="normalize-space(.)"/></languageTerm>
                    </xsl:otherwise>
                </xsl:choose>
            </language>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:medium">
        <xsl:choose>
            <xsl:when test="contains(lower-case(.), 'application')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027002">application forms</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'audio cassette')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028661">audiocassettes</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'audio')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028633">sound recordings</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'interview')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'biography')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080102">biographies (documents)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'book')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'booklet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311670">booklets</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'business card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026767">business cards</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'certificate')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026841">certificates</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'check')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300191339">checks (bank checks)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'digital image')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300215302">digital images</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'digital video')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300312050">digital moving image formats</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'document')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026030">documents</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'email')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300149026">electronic mail</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'exam')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026936">examinations (documents)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'flier') or contains(lower-case(.), 'flyer')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300224742">fliers (printed matter)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'form')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300049060">forms (documents)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'handbill') or contains(lower-case(.), 'handout')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027033">handbills</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'notes')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'sheet music')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026430">sheet music</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'image')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'label')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028730">labels (identifying artifacts)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'letter')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026879">letters (correspondence)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'balance sheet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027486">balance sheets</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'manual')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026395">manuals (instructional materials)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'map')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'memo')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026906">memorandums</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'newsletter')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026652">newsletters</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'newspaper')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'magnetic tape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028558">magnetic tapes</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'pamphlet') or contains(lower-case(.), 'pamplet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'copy')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300257688">copies (document genres)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'photograph') or contains(lower-case(.), 'phothgraph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'postage')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300037321">postage stamps</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'postcard')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'poster')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'program')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'receipt')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027573">receipts (financial records)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'speech')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026671">speeches (documents)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'sticker')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300207379">stickers</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'tape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300014685">tape (materials)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'text')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'tickets')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300133073">admission tickets</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'video')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028682">video recordings</genre>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'voucher')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027574">vouchers (sales records)</genre>
            </xsl:when>
            <xsl:otherwise>
                <genre><xsl:value-of select="normalize-space(lower-case(.))"/></genre>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:medium" mode="form">
        <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
    </xsl:template>
    
    <xsl:template match="dc:provenance">
        <xsl:if test="not(contains(lower-case(.), 'n/a') or contains(lower-case(.), 'born digital'))">
            <relatedItem type="host" displayLabel="Collection">
                <titleInfo>
                    <title><xsl:value-of select="."/></title>
                </titleInfo>
            </relatedItem>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:provenance" mode="digitalOrigin">
        <xsl:if test="not(contains(lower-case(.), 'n/a')) and contains(lower-case(.), 'born digital')">
            <digitalOrigin><xsl:value-of select="normalize-space(lower-case(.))"/></digitalOrigin>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> <!-- will block publisher being the institution/collection -->
        <xsl:if test="normalize-space(.)!='' and not(contains(lower-case(normalize-space(dc:publisher)),'crossroads to freedom'))">
            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:relation">
        <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
            <xsl:choose>
                <xsl:when test="contains(.,'http')"> 
                    <relatedItem>
                        <location>
                            <url><xsl:value-of select="normalize-space(.)"/></url>
                        </location>
                    </relatedItem>
                </xsl:when>
                <xsl:when test="starts-with(., 'rds:')">
                    <relatedItem>
                        <identifier type="pid"><xsl:value-of select="normalize-space(.)"/></identifier>
                    </relatedItem>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'Tennessee')">
                    <subject>
                        <geographic><xsl:value-of select="normalize-space(.)"/></geographic>
                    </subject>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), '^\d{4}')">
                    <subject>
                        <temporal><xsl:value-of select="normalize-space(.)"/></temporal>
                    </subject>
                </xsl:when>
                <xsl:otherwise>
                    <relatedItem>
                        <titleInfo>
                            <title><xsl:value-of select="normalize-space(.)"/></title>
                        </titleInfo>
                    </relatedItem>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
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
    
    <!-- The top spatial facets that cover about 99% of the total records are accounted for in the template below. This process was semi automated using OpenRefine in the context of this particular collection -->
    
    <xsl:template match="dc:spatial">
        <xsl:if test="not(matches(., '\d+\S+')) and not(contains(normalize-space(lower-case(.)), 'n/a')) and not(contains(normalize-space(lower-case(.)), 'unknown')) and not(contains(normalize-space(lower-case(.)), 'various'))"> <!-- data contains some random numbers/dates -->
            <xsl:for-each select="tokenize(., ' and ')">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'evergreen') and contains(normalize-space(lower-case(.)),'memphis') and contains(normalize-space(lower-case(.)),'tennessee')">
                        <subject>
                            <geographic>Evergreen Historic District (Memphis, Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.1479, -90.0072</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'memphis') and contains(normalize-space(lower-case(.)),'tennessee')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78095779">Memphis (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.14953, -90.04898</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'albany') and contains(normalize-space(lower-case(.)),'georgia')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n81107844">Albany (Ga.)</geographic>
                            <cartographics>
                                <coordinates>31.57851, -84.15574</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'alcoa') and contains(normalize-space(lower-case(.)),'tennessee')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n80022862">Alcoa (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.78953, -83.97379</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'alexandria') and contains(normalize-space(lower-case(.)),'virginia')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79099306">Alexandria (Va.)</geographic>
                            <cartographics>
                                <coordinates>38.80484, -77.04692</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'anderson') and contains(normalize-space(lower-case(.)),'indiana')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n50074868">Anderson (Ind.)</geographic>
                            <cartographics>
                                <coordinates>40.10532, -85.68025</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'atlanta') and contains(normalize-space(lower-case(.)),'georgia')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79023214">Atlanta (Ga.)</geographic>
                            <cartographics>
                                <coordinates>33.749, -84.38798</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'brownsville') and contains(normalize-space(lower-case(.)),'tennessee')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n84008639">Brownsville (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.59397, -89.26229</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'attala') and contains(normalize-space(lower-case(.)),'mississippi')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n82101331">Attala County (Miss.)</geographic>
                            <cartographics>
                                <coordinates>33.08629, -89.58155</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'hoxie') and contains(normalize-space(lower-case(.)),'arkansas')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n83030241">Hoxie (Ark.)</geographic>
                            <cartographics>
                                <coordinates>36.05035, -90.97512</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'tuscaloosa') and contains(normalize-space(lower-case(.)),'alabama')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79133761">Tuscaloosa (Ala.)</geographic>
                            <cartographics>
                                <coordinates>33.20984, -87.56917</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'nashville') and contains(normalize-space(lower-case(.)),'tennessee')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78095801">Nashville (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>36.16589, -86.78444</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'birmingham') and contains(normalize-space(lower-case(.)),'alabama')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79042167">Birmingham (Ala.)</geographic>
                            <cartographics>
                                <coordinates>33.52066, -86.80249</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'washington') and contains(normalize-space(lower-case(.)),'d.c.') or contains(normalize-space(lower-case(.)),'dc') or contains(normalize-space(lower-case(.)),'district of columbia')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79018774">Washington (D.C.)</geographic>
                            <cartographics>
                                <coordinates>38.89511, -77.03637</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'macon') and contains(normalize-space(lower-case(.)),'georgia')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79133192">Macon (Ga.)</geographic>
                            <cartographics>
                                <coordinates>32.84069, -83.6324</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'chicago') and contains(normalize-space(lower-case(.)),'illinois')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78086438">Chicago (Ill.)</geographic>
                            <cartographics>
                                <coordinates>41.85003, -87.65005</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'boston') and contains(normalize-space(lower-case(.)),'massachusetts')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79045553">Boston (Mass.)</geographic>
                            <cartographics>
                                <coordinates>42.35843, -71.05977</coordinates>
                            </cartographics>
                        </subject>
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <geographic>
                                <xsl:value-of select="normalize-space(.)"/>
                            </geographic>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:source">
        <xsl:choose>
            <xsl:when test="contains(lower-case(.), 'collection') or contains(lower-case(.), 'corp')">
                <relatedItem type="host" displayLabel="Collection">
                    <titleInfo>
                        <title><xsl:value-of select="normalize-space(.)"/></title>
                    </titleInfo>
                </relatedItem>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:source" mode="physicalLocation">
        <xsl:if test="contains(lower-case(.), 'archive') or contains(lower-case(.), 'library') or contains(lower-case(.), 'association') or starts-with(lower-case(normalize-space(.)), 'http://')">
            <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:variable name="subjlist" select="tokenize(., '[;/]')"/><!-- not really applicable for DSpace metadata but left as is -->
            <xsl:for-each select="$subjlist">
                <xsl:choose>
                    <xsl:when test="matches(.,'^\d{4}$')"> <!-- Contains some years -->
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="."/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <topic><xsl:value-of select="normalize-space(.)"/></topic>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:temporal">
        <xsl:choose>
            <xsl:when test="matches(., '^\d{4}$') or matches(., '^\d{4}-\d{2}$') or matches(., '^\d{4}-\d{2}-\d{2}$')">
                <subject>
                    <temporal encoding="edtf"><xsl:value-of select="."/></temporal>
                </subject>
            </xsl:when>
            <xsl:when test="contains(lower-case(.), 'unknown') or contains(lower-case(.), 'n/a')">
            </xsl:when>
            <xsl:when test="not(contains(., '\d+'))">
                <subject>
                    <geographic><xsl:value-of select="."/></geographic>
                </subject>
            </xsl:when>
            <xsl:otherwise>
                <subject>
                    <temporal><xsl:value-of select="."/></temporal>
                </subject>
            </xsl:otherwise>
        </xsl:choose>
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
