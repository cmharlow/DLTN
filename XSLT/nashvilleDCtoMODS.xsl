<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="rb">(</xsl:variable>
    <xsl:variable name="rd">)</xsl:variable>
    
    <xsl:include href="remediationgettygenre.xsl"/>
    <xsl:include href="remediationlcshtopics.xsl"/>
    <xsl:include href="remediationspatial.xsl"/>
    <xsl:include href="coredctomods.xsl"/>
    <xsl:include href="thumbnailscontentdmdctomods.xsl"/>
    
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
                            <temporal encoding="edtf"><xsl:value-of select="."/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{2}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{2}/\d{2}/\d{4}$')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="concat(concat(substring(.,7, 10),'-'), substring(., 1, 5))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{1}-\d{2}-\d{4}$') or matches(normalize-space(.), '^\d{1}/\d{2}/\d{4}$')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="concat(concat(substring(.,6, 9),'-'), substring(., 1, 4))"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '19th century')">
                        <subject>
                            <temporal encoding="edtf">18uu</temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), '20th century')">
                        <subject>
                            <temporal encoding="edtf">19uu</temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'c. ')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'ca. ')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space(.), 'between ')">
                        <subject>
                            <temporal encoding="edtf"><xsl:value-of select="replace(replace(normalize-space(.), 'between ', ''), ' and ', '/')"/></temporal>
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
    
    <xsl:template match="dc:publisher"> 
        <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(.), 'Archives')) and not(contains(normalize-space(.), 'Special Collections')) and not(contains(normalize-space(.), 'Metro'))">
            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
        </xsl:if>
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
                    <accessCondition><xsl:value-of select="normalize-space(.)"/></accessCondition>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="recordSource">
        <recordInfo>
            <recordContentSource>Nashville Public Library</recordContentSource>
            <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
        </recordInfo>
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
                <xsl:call-template name="LCSHtopic">
                    <xsl:with-param name="term"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="starts-with(normalize-space(.), '58 x 75 cm')">
                <note><xsl:value-of select="normalize-space(.)"/></note>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:call-template name="AATgenre">
                <xsl:with-param name="term"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
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
