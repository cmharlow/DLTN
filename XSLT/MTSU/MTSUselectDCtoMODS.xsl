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
            <xsl:apply-templates select="dc:identifier" mode="part"/>
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:contributor" /> <!-- name/role -->
            <xsl:apply-templates select="dc:creator" /> <!-- name/role -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:contributor|dc:creator|dc:publisher|dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:contributor" mode="repository" /> <!-- repository of physical item parsed form contributor field -->
                    <xsl:apply-templates select="dc:creator" mode="repository" /> <!-- repository of physical item parsed form creator field -->
                    <xsl:apply-templates select="dc:publisher" mode="repository" /> <!-- repository of physical item parsed form publisher field -->
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic, temporal subject info -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/><!-- genre -->
            <xsl:apply-templates select="dc:source"/>
            <xsl:apply-templates select="dc:type" mode="type"/> <!-- item types -->
            <recordInfo>
                <recordContentSource>Middle Tennessee State University Library</recordContentSource>
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
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(.), 'asst. bus. mgr')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', asst. bus. mgr.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Assistant business manager</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'bus. mgr')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', bus. mgr.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Business manager</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'mgr')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', mgr.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Manager</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'ed.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'eds.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', eds.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'speaker')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', speaker', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/spk">Speaker</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', interviewer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photo. ed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photo. ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Photographic editor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'recorder')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', recorder', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/rcd">Recordist</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'asst. ed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', asst. ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'illustrator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', illustrator', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                            </role>  
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'performer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', performer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prf">Performer</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'asst. dir')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', asst. dir.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Assistant director</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'editor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', editor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'assoc. ed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', assoc. ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role>   
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'faculty advisor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', faculty advisor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ths">Thesis advisor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'advisor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', advisor', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Advisor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'collaborator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', collaborator', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Collaborator</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'albert gore research center') or contains(normalize-space(lower-case(.)), 'center for historic preservation') or contains(normalize-space(lower-case(.)), 'center for popular music') or contains(normalize-space(lower-case(.)), 'digital initiatives') or contains(normalize-space(lower-case(.)), 'digital room') or contains(normalize-space(lower-case(.)), 'george peabody college') or contains(normalize-space(lower-case(.)), 'james e. walker library') or contains(normalize-space(lower-case(.)), 'special collections')">
                        <!-- mapped to repository in contributor mode:repository -->
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
    
    <xsl:template match="dc:contributor" mode="repository">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="contains(normalize-space(lower-case(.)), 'albert gore research center') or contains(normalize-space(lower-case(.)), 'center for historic preservation') or contains(normalize-space(lower-case(.)), 'center for popular music') or contains(normalize-space(lower-case(.)), 'digital initiatives') or contains(normalize-space(lower-case(.)), 'digital room') or contains(normalize-space(lower-case(.)), 'george peabody college') or contains(normalize-space(lower-case(.)), 'james e. walker library') or contains(normalize-space(lower-case(.)), 'special collections')">
                <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="."/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(normalize-space(.),1, 3),'/'), substring(., 5, 8))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(normalize-space(.),1, 3),'/'), substring(., 7, 10))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '19th century')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes">18uu</temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '20th century')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes">19uu</temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'c. ')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'ca. ')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'between ')">
                        <subject>
                            <temporal encoding="edtf" keyDate="yes"><xsl:value-of select="replace(replace(normalize-space(.), 'between ', ''), ' and ', '/')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'COVERAGE ')">
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'Worcester ')">
                        <subject>
                            <topical><xsl:value-of select="normalize-space(.)"/></topical>
                        </subject>
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <temporal><xsl:value-of select="normalize-space(.)"/></temporal>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'unknown'))">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(.), 'artist')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', artist', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">Artist</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'architect')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', architect', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Architect')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Architect', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'cartographer and engraver')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', cartographer and engraver', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctg">Cartographer</roleTerm>
                            </role>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">Engraver</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'editor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', editor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'compiler')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', compiler', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/com">Compiler</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'engravers')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', engravers', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">Engraver</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'engraver')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', engraver', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">Engraver</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), ',interviewee')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ',interviewee', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ive">Interviewee</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'interviewee')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', interviewee', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ive">Interviewee</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', interviewer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Interviewer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'map')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', map', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctg">Cartographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Photographers')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Photographers', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photograph')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photograph', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'sculptor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', sculptor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">Sculptor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'text')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', text', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aut">Author</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'center for historic preservation')">
                        <!-- mapped to repository in creator mode:repository -->
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
            </xsl:if>  
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator" mode="repository">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="contains(normalize-space(lower-case(.)), 'center for historic preservation') and normalize-space(.)!=''">
                <publisher><xsl:value-of select="replace(normalize-space(.), ' (Publisher)', '')"/></publisher>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:date"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
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
                <!-- Numbers only but not EDTF -->
                    <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(normalize-space(.),1, 4),'/'), substring(., 6, 8))"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(concat(substring(normalize-space(.),1, 4),'/'), substring(., 8, 10))"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- APPROXIMATE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'circa') or contains(normalize-space(lower-case(.)), 'c.') or contains(normalize-space(lower-case(.)), 'ca.') or contains(normalize-space(lower-case(.)), 'cia.')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), 'c. \d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}-\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),1, 4),'/'), substring(., 6, 8)), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), 'ca. \d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^ca. \d{4}-\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),2, 5),'/'), substring(., 7, 9)), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), 'circa \d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^circa \d{4}-\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),4, 7),'/'), substring(., 9, 11)), '~')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="approximate"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                <!-- Record Creation Timestamps in DC record - ignored -->
                    <xsl:when test="starts-with(normalize-space(lower-case(.)), 'ap') or starts-with(normalize-space(lower-case(.)), 'mt')">
                        <!-- do nothing -->
                    </xsl:when>
                <!-- QUESTIONABLE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '?')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\d{4}?$')">
                                <dateCreated encoding="edtf" qualifier="questionable" keyDate="yes"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}?\]$')">
                                <dateCreated encoding="edtf" qualifier="questionable" keyDate="yes"><xsl:value-of select="replace(replace(normalize-space(.), '\[', ''), '\]', '')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}?$')">
                                <dateCreated encoding="edtf" keyDate="yes" qualifier="questionable"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),2, 5),'/'), substring(., 7, 9)), '?')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="questionable"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- INFERRED -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '[')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="replace(replace(normalize-space(.), '\[', ''), '\]', '')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="inferred"><xsl:value-of select="normalize-space(.)"/></dateCreated>
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
        <xsl:for-each select="tokenize(replace(normalize-space(.), '\)', ''), '\(')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                <!-- EXTENT -->
                    <xsl:when test="matches(normalize-space(lower-case(.)), '\d+') and not(contains(normalize-space(lower-case(.)), 'mp3')) and not(contains(normalize-space(lower-case(.)), 'jp2')) and not(contains(normalize-space(lower-case(.)), 'jpeg2000'))">
                        <extent><xsl:value-of select="normalize-space(.)"/></extent>
                    </xsl:when>
                <!-- INTERNETMEDIATYPE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'jpeg2000')">
                        <internetMediaType>image/jpeg2000</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'jpeg') or contains(normalize-space(lower-case(.)), 'jpg')">
                        <internetMediaType>image/jpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'jp2')">
                        <internetMediaType>image/jp2</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'pdf')">
                        <internetMediaType>application/pdf</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'mp3')">
                        <internetMediaType>audio/mp3</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'tif')">
                        <internetMediaType>image/tiff</internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'mov')">
                        <internetMediaType>video/mov</internetMediaType>
                    </xsl:when>
                <!-- FORM -->
                    <xsl:otherwise>
                        <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="genre">
        <xsl:for-each select="tokenize(replace(normalize-space(.), '\)', ''), '\(')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'advertisement')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193993">advertisements</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'album')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026690">albums (books)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'article')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300048715">articles</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'autobiography')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080104">autobiographies</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'bibliography')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026497">bibliographies</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'biography')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080102">biographies (documents)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'book')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'booklet')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311670">booklets</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'brochure')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300248280">brochures</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'clipping')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026867">clippings (information artifacts)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'computer disk')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300266292">hard disks</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'correspondence')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026877">correspondence</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'directory')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026234">directories</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'drawings')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033973">drawings (visual works)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'ephemera')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028881">ephemera (general)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'fieldnotes')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027201">field notes</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'film')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300014637">film (material by form)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'government publication')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027777">government records</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'handbook')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311807">handbooks</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'image')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'index')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026554">indexes (reference sources)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'instruction')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027042">instructions (document genre)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'interview')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'invitation')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027083">invitations</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'leaflet')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300211825">leaflets (printed works)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'legal case and case notes')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'map')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'memoir')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202559">memoirs</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'newspaper')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'oral history')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202595">oral histories (document genres)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'painting')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033618">paintings (visual works)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'pamphlet')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'paper')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300199056">papers (document genres)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'periodical')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026657">periodicals</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'photograph')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'portrait')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015637">portraits</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'postcard')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'poster')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'program')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'slide')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128371">slides (photographs)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'speech')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026671">speeches (documents)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'survey')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300226986">surveys (documents)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'technical report')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027323">technical reports</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'thesis')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028028">theses</genre>
                    </xsl:when>
                </xsl:choose>
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
    
    <xsl:template match="dc:identifier" mode="part">
        <xsl:if test="normalize-space(.)!='' and starts-with(lower-case(normalize-space(.)), 'volume')">
            <part>
                <detail>
                    <number><xsl:value-of select="normalize-space(.)"/></number>
                </detail>
            </part>
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
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:for-each select="tokenize(normalize-space(.), ' and ')">
                <xsl:if test="normalize-space(.)!=''">
                    <language>
                        <xsl:choose>
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'eng')">
                                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                            </xsl:when>
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'dutch')">
                                <languageTerm type="code" authority="iso639-2b">dut</languageTerm>
                            </xsl:when>
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'fr')">
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
                            <xsl:otherwise>
                                <languageTerm type="text"><xsl:value-of select="normalize-space(.)"/></languageTerm>
                            </xsl:otherwise>
                        </xsl:choose>
                    </language>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'albert gore')) and not(contains(normalize-space(lower-case(.)), 'arts center')) and not(contains(normalize-space(lower-case(.)), 'center for historic preservation')) and not(contains(normalize-space(lower-case(.)), 'james e. walker library')) and not(contains(normalize-space(lower-case(.)), 'tennessee state library'))">
                <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher" mode="repository"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(lower-case(.)), 'albert gore') or contains(normalize-space(lower-case(.)), 'arts center') or contains(normalize-space(lower-case(.)), 'center for historic preservation') or contains(normalize-space(lower-case(.)), 'james e. walker library') or contains(normalize-space(lower-case(.)), 'tennessee state library')">
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
                    <xsl:when test="contains(normalize-space(lower-case(.)),'collection')"> 
                        <relatedItem type='host' displayLabel='Collection'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'publication')"> 
                        <relatedItem type='host'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                        </relatedItem>
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
                <note><xsl:value-of select="normalize-space(.)"/></note>
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
    
    <xsl:template match="dc:type" mode="MIME">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'application/pdf')">
                        <internetMediaType><xsl:value-of select="normalize-space(lower-case(.))"/></internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'audio/mp3')">
                        <internetMediaType><xsl:value-of select="normalize-space(lower-case(.))"/></internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'image/jpeg')">
                        <internetMediaType><xsl:value-of select="normalize-space(lower-case(.))"/></internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'video/mov')">
                        <internetMediaType><xsl:value-of select="normalize-space(lower-case(.))"/></internetMediaType>
                    </xsl:when>
                </xsl:choose>
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
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
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
