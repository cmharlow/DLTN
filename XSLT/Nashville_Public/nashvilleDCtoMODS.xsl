<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="rb">(</xsl:variable>
    <xsl:variable name="rd">)</xsl:variable>
    
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
                <xsl:apply-templates select="dc:contributor" mode="date" /> <!-- stray dates in contributor field -->
                <xsl:apply-templates select="dc:publisher"/> <!-- place of origin - publishers all repositories -->
                <xsl:apply-templates select="dc:contributor" mode="publisher" /> <!-- publisher of physical item parsed form contributor field -->
                <xsl:apply-templates select="dc:creator" mode="publisher" /> <!-- publisher of physical item parsed form creator field -->
            </originInfo>
            
            <physicalDescription>
                <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                <xsl:apply-templates select="dc:source" mode="physicalNote"/> <!-- some physical notes type fields -->
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
            <xsl:apply-templates select="dc:publisher" mode="rights"/>
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic subject info -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/><!-- genre -->
            <xsl:apply-templates select="dc:source"/>
            <xsl:apply-templates select="dc:type" mode="type"/> <!-- item types -->
            <recordInfo>
                <recordContentSource>Public Library of Nashville and Davidson County</recordContentSource>
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
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <!-- will be handled in contributor mode date -->
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Illustrator and Designer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Illustrator and Designer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dsr">Designer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Illlustrator and Designer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Illlustrator and Designer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dsr">Designer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Desiger and Illustrator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Desiger and Illustrator)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dsr">Designer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Editor and Introduction')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Editor and Introduction)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aui">Author of introduction, etc.</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Introduction and Translator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Introduction and Translator)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aui">Author of introduction, etc.</roleTerm>
                            </role>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trl">Translator</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Translator and Editor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Introduction and Translator)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trl">Translator</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Translator and Introduction')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Introduction and Translator)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aui">Author of introduction, etc.</roleTerm>
                            </role>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trl">Translator</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Architect')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Architect)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Arranger')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Arranger)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arr">Architect</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Co-author')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Co-author)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aut">Author</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Collector')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Collector)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/col">Collector</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Correspondent')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Correspondent)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/crp">Architect</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Designer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Designer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dsr">Designer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Distributor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Distributor)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dst">Distributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Digitization, Metadata Cataloger')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Digitization, Metadata Cataloger)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/mdc">Metadata contact</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'donor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (donor)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dnr">Donor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Donor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Donor)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/dnr">Donor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Forward')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Forward)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aui">Author of introduction, etc.</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Illustrator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Illustrator)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                            </role>  
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Introduction')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Introduction)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aui">Author of introduction, etc.</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Lyricist')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Lyricist)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/lyr">Lyricist</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Photographer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Preface')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Preface)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/wpr">Writer of preface</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Printer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Printer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prt">Printer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Publisher')">
                        <!-- mapped to publisher in contributor mode:publisher -->
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Sculptor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Sculptor)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">Sculptor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Translator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Translator)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trl">Translator</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Transcriber')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Transcriber)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trc">Transcriber</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Videographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Videographer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/vdg">Videographer</roleTerm>
                            </role> 
                        </name>
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
    
    <xsl:template match="dc:contributor" mode="date">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:contributor" mode="publisher">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="contains(normalize-space(.), 'Publisher')">
                <publisher><xsl:value-of select="replace(normalize-space(.), ' (Publisher)', '')"/></publisher>
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
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(.), 'Artist')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Artist)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">Artist</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Author')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Author)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aut">Author</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Cartographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Cartographer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctg">Cartographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Cartoonist')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Cartoonist)', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Cartoonist</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Collector')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Collector)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/col">Collector</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Compiler')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Compiler)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/com">Compiler</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Composer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Composer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cmp">Composer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Correspondent')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Correspondent)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/crp">Correspondent</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Interviewee')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Interviewee)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ive">Interviewee</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Interviewer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Photographer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (photographer)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Photographers')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Photographers)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Publisher')">
                        <!-- mapped to publisher in creator mode:publisher -->
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'storyteller')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (storyteller)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Storyteller</roleTerm>
                            </role> 
                        </name> 
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
    
    <xsl:template match="dc:creator" mode="publisher">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="contains(normalize-space(.), 'Publisher')">
                <publisher><xsl:value-of select="replace(normalize-space(.), ' (Publisher)', '')"/></publisher>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:date"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{2}.\d{1}x\d{2}.\d{1}$')"> <!-- weird scientific date kinda numbers not mapped -->
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
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
                    <xsl:when test="starts-with(normalize-space(.), 'c. ')">
                        <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'circa ')">
                        <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'circa ', ''), '~')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^ca. \d{4}$') or matches(normalize-space(.), '^ca. \d{4}-\d{2}$') or matches(normalize-space(.), '^ca. \d{4}-\d{2}-\d{2}$') ">
                        <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(lower-case(.)), 'between ')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(replace(replace(normalize-space(lower-case(.)), 'between ', ''), ' and ', '/'), '-', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(lower-case(.))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(lower-case(.)), 'ca. between ')">
                        <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="replace(replace(replace(normalize-space(lower-case(.)), 'ca. between ', ''), ' and ', '/'), '-', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(lower-case(.))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), '?')">
                        <dateCreated qualifier="questionable" ><xsl:value-of select="normalize-space(lower-case(.))"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'n.d.') or contains(normalize-space(lower-case(.)), 'n/a') or contains(normalize-space(lower-case(.)), 'unknown')">
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
    
    <xsl:template match="dc:format">
        <xsl:for-each select="tokenize(replace(normalize-space(.), '\)', ''), '\(')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image/jp2') or matches(normalize-space(lower-case(.)), 'image/jpeg') or matches(normalize-space(lower-case(.)), 'image/pdf') or matches(normalize-space(lower-case(.)), 'image/tiff') or matches(normalize-space(lower-case(.)), 'text/plain') or matches(normalize-space(lower-case(.)), 'video/mp4') or matches(normalize-space(lower-case(.)), 'audio/mp3') or matches(normalize-space(lower-case(.)), 'video/vob')">
                        <internetMediaType><xsl:value-of select="normalize-space(.)"/></internetMediaType>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'image') and contains(normalize-space(lower-case(.)), 'jpeg')">
                        <internetMediaType>image/jpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '\d+')">
                        <extent><xsl:value-of select="normalize-space(.)"/></extent>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'insert size and time')">
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'dvd')">
                        <form>DVD</form>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'photographs')">
                        <form>photographs</form>
                    </xsl:when>
                    <xsl:otherwise>
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="genre">
        <xsl:for-each select="tokenize(replace(normalize-space(.), '\)', ''), '\(')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'dvd')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264677">DVDs</genre>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'photographs')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
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
    
    <xsl:template match="dc:identifier" mode="locationurl">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'http')"> 
            <!-- CONTENTdm puts the URI in an <identifier> field in the OAI record -->
            <url usage="primary display" access="object in context"><xsl:value-of select="$idvalue"/></url> <!-- ref url-->          
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
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'english')">
                                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                            </xsl:when>
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'dutch')">
                                <languageTerm type="code" authority="iso639-2b">dut</languageTerm>
                            </xsl:when>
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'french')">
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
                            <xsl:when test="contains(normalize-space(lower-case(.)),'baptist')">
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
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(.), 'Archives')) and not(contains(normalize-space(.), 'Special Collections')) and not(contains(normalize-space(.), 'Metro'))">
                <xsl:for-each select="tokenize(normalize-space(.), ':')">
                    <xsl:choose>
                        <xsl:when test="contains(normalize-space(.), 'New York') or contains(normalize-space(.), 'San Fran')">
                            <place><xsl:value-of select="normalize-space(.)"/></place>
                        </xsl:when>
                        <xsl:otherwise>
                            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher" mode="repository"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(starts-with(normalize-space(.), 'U.S. and international copyright laws'))">
                <xsl:if test="contains(normalize-space(.), 'Archives') or contains(normalize-space(.), 'Metro') or contains(normalize-space(.), 'Special Collections')">
                    <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher" mode="rights"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="starts-with(normalize-space(.), 'U.S. and international copyright laws')">
                    <accessCondition type="use and repoduction"><xsl:value-of select="normalize-space(.)"/></accessCondition>
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
                    <xsl:when test="contains(.,'Atlas of the city')"> 
                        <relatedItem type='host'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                        </relatedItem>
                    </xsl:when>
                    <xsl:otherwise>
                        <relatedItem type='host' displayLabel='Collection'>
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
                <xsl:choose>
                    <xsl:when test="contains(normalize-space(lower-case(.)),'donation')"> 
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'Wilson ')">
                        <relatedItem>
                            <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Collection ')">
                        <relatedItem>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                        </relatedItem>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:source" mode="physicalNote">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="not(contains(normalize-space(lower-case(.)),'donation')) and not(starts-with(normalize-space(.), 'Wilson ')) and not(contains(normalize-space(.), 'Collection '))"> 
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(starts-with(normalize-space(.), '58 x 75 cm'))">
                <subject>
                    <topic><xsl:value-of select="normalize-space(.)"/></topic>
                </subject>
            </xsl:if>
            <xsl:if test="starts-with(normalize-space(.), '58 x 75 cm')">
                <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:choose>
                <xsl:when test="matches(normalize-space(.), 'Advertisements')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193993">advertisements</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Aerial photographs')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128222">aerial photographs</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Architectural photographs')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Book')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Book covers')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300197210">covers (closures)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Bookplates')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028731">bookplates</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Broadside')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026739">broadsides (notices)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Brochure')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300248280">brochures</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Cabinet photographs')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127131">cabinet photographs</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Calendars')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026741">calendars</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Cards')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026756">cards (information artifacts)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Caricatures')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015634">caricatures</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Cartes-de-visite')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127141">cartes-de-visite (card photographs)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Cartoons (Commentary)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300123431">editorial cartoons</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Chart')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026848">charts (graphic documents)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Christmas cards')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026782">Christmas cards</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Clippings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026867">clippings (information artifacts)</genre>
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Commercial correspondence')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026914">commercial correspondence</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Correspondence')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026877">correspondence</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Digital prints')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300312222">digital prints</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Document')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026030">documents</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Drawings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033973">drawings (visual works)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Editorial cartoons')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300123431">editorial cartoons</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Envelope')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300197601">envelopes</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Ephemera')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028881">ephemera (general)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Film negatives')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127173">negatives (photographic)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Film transparencies')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127478">transparencies</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Government records')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027777">government records</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Image')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Invitation')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027083">invitations</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Letters (correspondence)')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026879">letters (correspondence)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Maps')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Military records')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027822">military records</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Monthly reports')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027288">monthly reports</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Negative')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127173">negatives (photographic)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Official reports')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027294">official reports</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'oral histories')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202595">oral histories (document genres)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Paintings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033618">paintings (visual works)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Pamphlets')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'photograph album')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026695">photograph albums</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'photo')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'sculpture')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300047090">sculpture (visual work)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Portrait')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015637">portraits</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Postcards')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Print advertising')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300213176">print advertising</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Programs')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Reports')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027267">reports</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Scores')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026427">scores</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Sheet music covers')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026430">sheet music</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Sketchbooks')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027354">sketchbooks</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Sketches')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015617">sketches</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Slide')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128371">slides (photographs)</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Snapshots')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300134745">snapshots</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Interview')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Souvenir programs')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">souvenir programs</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Stock certificates')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027558">stock certificates</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Telegrams')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026909">telegrams</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Transparencies')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127478">transparencies</genre>
                </xsl:when>
                <xsl:when test="contains(normalize-space(.), 'Wills')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027764">wills</genre>
                </xsl:when>
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
                <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'map')">
                    <typeOfResource>cartographic</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'score')">
                    <typeOfResource>notated music</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'sound')">
                    <typeOfResource>sound recording</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'still image') or contains(normalize-space(lower-case(.)), 'image')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'video')">
                    <typeOfResource>moving image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'sculpture')">
                    <typeOfResource>three dimensional object</typeOfResource>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
