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
                <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
            </originInfo>
            
            <physicalDescription>
                <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
            </physicalDescription>
            
            <location>
                <xsl:apply-templates select="dc:publisher" mode="repository"/>
                <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
            </location>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic subject info -->
            <xsl:apply-templates select="dc:type"/> <!-- genre -->
            <xsl:apply-templates select="dc:type" mode="type"/> <!-- item types -->
            <recordInfo>
                <recordContentSource>University of Tennessee, Chattanooga</recordContentSource>
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
            <xsl:if test="normalize-space(.)!=''">
                <name>
                    <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                    </role> 
                </name>      
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), 'Chattanooga (Tenn.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79075123">Chattanooga (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.04563, -85.30968</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Walden Ridge (Tenn.)')">
                        <subject>
                            <geographic>Walden Ridge (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.54035, -85.06079</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Nashville (Tenn.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78095801">Nashville (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>36.16589, -86.78444</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Indianapolis (Ind.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79055094">Indianapolis (Ind.)</geographic>
                            <cartographics>
                                <coordinates>39.76838, -86.15804</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Sand Mountain (Ala.)')">
                        <subject>
                            <geographic>Sand Mountain (Ala.)</geographic>
                            <cartographics>
                                <coordinates>32.85485, -86.91249</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Murfreesboro (Tenn.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n50071679">Murfreesboro (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.84562, -86.39027</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Washington (D.C.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79018774">Washington (D.C.)</geographic>
                            <cartographics>
                                <coordinates>38.91706, -77.00025</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Chickamauga (Ga.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n91047626">Chickamauga (Ga.)</geographic>
                            <cartographics>
                                <coordinates>34.87119, -85.29079</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Royal Air Force Station, Martlesham Heath (Suffolk)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n84120766">Royal Air Force Station, Martlesham Heath (Suffolk)</geographic>
                            <cartographics>
                                <coordinates>52.058, 1.266</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), 'Columbia (Tenn.)')">
                        <subject>
                            <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n83226061">Columbia (Tenn.)</geographic>
                            <cartographics>
                                <coordinates>35.61507, -87.03528</coordinates>
                            </cartographics> 
                        </subject> 
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <geographic><xsl:value-of select="normalize-space(.)"/></geographic>
                        </subject> 
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <name>
                    <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                    <role>
                        <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                    </role>
                </name>
            </xsl:if>  
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:date"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}T.'))">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:otherwise>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:description">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), 'image/jp2') or matches(normalize-space(.), 'text/plain') or matches(normalize-space(.), 'video/mp4')">
                        <internetMediaType><xsl:value-of select="normalize-space(.)"/></internetMediaType>
                    </xsl:when>
                    <xsl:otherwise>
                        <extent><xsl:value-of select="normalize-space(.)"/></extent>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
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
    
    <xsl:template match="dc:identifier" mode="locationurl">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'http')"> 
            <!-- CONTENTdm puts the URI in an <identifier> field in the OAI record -->
            <location><url usage="primary display" access="object in context"><xsl:value-of select="$idvalue"/></url></location> <!-- ref url-->          
            <!-- process identifier into CONTENTdm 6.5 thumbnail urls --> 
            <xsl:variable name="contentdmroot" select="substring-before($idvalue,'/cdm/ref/')"/>
            <xsl:variable name="recordinfo" select="substring-after($idvalue,'/cdm/ref/collection/')"/>
            <xsl:variable name="alias" select="substring-before($recordinfo,'/id/')"/>
            <xsl:variable name="pointer" select="substring-after($recordinfo,'/id/')"/>
            <location><url access="preview"><xsl:value-of select="concat($contentdmroot,'/utils/getthumbnail/collection/',$alias,'/id/',$pointer)"/></url></location> <!--CONTENTdm thumbnail url-->
            <!-- end CONTENTdm thumbnail url processing -->           
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <language>
                    <xsl:choose>
                        <xsl:when test="normalize-space(lower-case(.))='en' or normalize-space(lower-case(.))='eng' or normalize-space(lower-case(.))='english'">
                            <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                        </xsl:when>
                        <xsl:when test="normalize-space(lower-case(.))='deu' or normalize-space(lower-case(.))='german'">
                            <languageTerm type="code" authority="iso639-2b">deu</languageTerm>
                        </xsl:when>
                        <xsl:otherwise>
                            <languageTerm type="text"><xsl:value-of select="normalize-space(.)"/></languageTerm>
                        </xsl:otherwise>
                    </xsl:choose>
                </language>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="matches(normalize-space(.), 'Chattanooga (Tenn.)')">
                    <place><xsl:value-of select="normalize-space(.)"/></place>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher" mode="repository"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(.), 'University')">
                    <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:relation">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(.,'http')"> 
                        <relatedItem>
                            <location>
                                <url><xsl:value-of select="normalize-space(.)"/></url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:otherwise>
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
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
            <xsl:choose>
                <xsl:when test="matches(normalize-space(.), 'Administrative records')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027425">administrative records</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Admission tickets')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300133073">admission tickets</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Agreements')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027628">agreements</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Articles')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300048715">articles</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Biograhies (Documents)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080102">biographies (documents)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Comprehensive plans (Reports)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027299">comprehensive plans (reports)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Correspondence')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026877">correspondence</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Decisions')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027857">decisions</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Dedications (Documents)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026114">dedications (documents)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Diaries')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027112">diaries</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Employment references')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026896">letters of recommendation</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Essays')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026291">essays</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Field recordings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300265794">field recordings</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'First drafts')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026932">first drafts</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Greeting cards')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026778">greeting cards</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Histories (Literature genre)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026358">histories (literature genre)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Legal correspondence')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026920">legal correspondence</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Legal documents')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027590">legal documents</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Line drawings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300100194">line drawings (drawings)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Local histories')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300251993">local histories</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Manuscript maps')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028461">manuscript maps</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Memorandums')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026906">memorandums</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Minutes (Administrative records)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027440">minutes (administrative records)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Moving image')">
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Newsletters')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026652">newsletters</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Newspapers')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Notes')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Oil paintings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033799">oil paintings (visual works)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Outlines')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027207">outlines (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Pamphlets')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Petitions')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027219">petitions</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Photographic prints')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127104">photographic prints</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Picture postcards')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026819">picture postcards</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Portraits')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015637">portraits</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Postcards')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Programs (Documents)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Questionnaires')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027265">questionnaires</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Receipts')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027573">receipts (financial records)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Records')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026685">records (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Registers')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027168">registers (lists)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Resolutions (Administrative records)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027457">resolutions (administrative records)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Rosters')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027178">rosters</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Rules (Administrative instructions)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027458">rules (administrative instructions)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'School yearbooks')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028024">school yearbooks</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Sketches')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015617">sketches</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Speeches')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026671">speeches (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Still image')">
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Studies')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300081053">studies (visual works)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Text')">
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Thumbnail sketches')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300075467">thumbnail sketches</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Tone drawings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300100222">tone drawings</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Transcripts')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027388">transcripts</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Watercolors')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300078925">watercolors (paintings)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Woodcuts (Prints)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300041405">woodcuts (prints)</genre>
                </xsl:when>
                <xsl:otherwise>
                    <genre><xsl:value-of select="normalize-space(lower-case(.))"/></genre>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type" mode="form">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type" mode="type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(.), 'Still image')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Moving image')">
                    <typeOfResource>moving image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
                <xsl:otherwise>
                    <typeOfResource>text</typeOfResource>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
