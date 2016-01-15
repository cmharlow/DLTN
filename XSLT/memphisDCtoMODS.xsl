<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="remediationgettygenre.xsl"/>
    <xsl:include href="remediationlcshtopics.xsl"/>
    <xsl:include href="remediationspatial.xsl"/>
    <xsl:include href="thumbnailscontentdmdctomods.xsl"/>
    <xsl:include href="coredctomods.xsl"/>
    
    <!-- OAI-DC to MODS Memphis Public Institution-Level Transformations. Includes the following templates:
        dc:contributor
        dc:contributor mode=publisher
        dc:creator
        dc:format mode=genre
        dc:identifier mode=shelfLocator
        dc:publisher (left at institution level to remove/block institution that digitized as publisher)
        recordInfo (static value for all Memphis Public Library collections)
        dc:relation
        dc:source
        dc:source mode=repository
        dc:subject
        dc:type
    -->
    
    <xsl:template match="dc:contributor">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:for-each select="tokenize(normalize-space(.), ' and ')">
                <xsl:for-each select="tokenize(normalize-space(.), ' &amp; ')">
                    <xsl:for-each select="tokenize(normalize-space(.), ' - ')">
                        <xsl:for-each select="tokenize(normalize-space(.), '&lt;br&gt;')">
                            <xsl:if test="normalize-space(.)!=''">
                                <xsl:choose>
                                    <xsl:when test="contains(normalize-space(.), 'additional research by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'additional research by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/res">Researcher</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Ansco Color by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Ansco Color by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/clr">Colorist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Cartoon by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Cartoon by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Cartoonist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Collection processed by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Collection processed by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cor">Collection registrar</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Collection revised by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Collection revised by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/spk">Collection revisor</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Color by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Color by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/clr">Colorist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Color-foto by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Color-foto by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/clr">Colorist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Cover design by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Cover design by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cov">Cover designer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'cartoonist')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (cartoonist)', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Cartoonist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'editors')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ', editors', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                                            </role>  
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'asst. dir.')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ', asst. dir.', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Assistant director</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'digitized by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'digitized by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Digitizer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Digitized by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Digitized by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Digitizer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
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
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), ', Editor')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Editor', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Editor')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), '(Editor)', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Identification by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Identification by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Identifier</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Index created by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Index created by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Indexer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Item scanned by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Item scanned by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Digitizer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'photographer')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), '(photographer)', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Manuscript Collection processed by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Manuscript Collection processed by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cor">Collection registrar</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Manuscript collection processed by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Manuscript collection processed by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cor">Collection registrar</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name> 
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'processed by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'processed by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cor">Collection registrar</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Archivist')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Archivist', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Archivist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Natural Color Photo')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Natural Color Photo ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Painting by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Painting by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">Artist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Illustrations')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ' (Illustrations)', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Staff Photo by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Staff Photo by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Photo by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Photo by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Photos by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Photos by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Typing by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Typing by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Typist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Processed by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Processed by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cor">Collection registrar</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Produced by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Produced by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pro">Producer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Recorded by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Recorded by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/rcd">Recordist</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Revised by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Revised by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Reviser</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Scanned by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Scanned by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text">Digitizer</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Sculptures by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Sculptures by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">Sculptor</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Transcribed and Compiled')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Transcribed and Compiled by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trc">Transcriber</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/com">Compiler</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(.), 'Transcription by')">
                                        <name>
                                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Transcription by ', '')"/></namePart>
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/trc">Transcriber</roleTerm>
                                            </role> 
                                            <role>
                                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                                            </role> 
                                        </name>
                                    </xsl:when>
                                    <xsl:when test="starts-with(lower-case(normalize-space(.)), 'donaed') or starts-with(lower-case(normalize-space(.)), 'gift') or starts-with(lower-case(normalize-space(.)), 'courtesy') or starts-with(lower-case(normalize-space(.)), 'doanted') or starts-with(lower-case(normalize-space(.)), 'donation') or starts-with(lower-case(normalize-space(.)), 'donor') or starts-with(lower-case(normalize-space(.)), 'donated') or starts-with(lower-case(normalize-space(.)), 'loaned') or starts-with(lower-case(normalize-space(.)), 'in honor') or starts-with(lower-case(normalize-space(.)), 'holdings') or starts-with(lower-case(normalize-space(.)), 'thanks') or starts-with(lower-case(normalize-space(.)), 'family of')">
                                        <note><xsl:value-of select="normalize-space(.)"/></note>
                                    </xsl:when>
                                    <xsl:when test="starts-with(lower-case(normalize-space(.)), 'description from') or starts-with(lower-case(normalize-space(.)), 'from') or contains(lower-case(normalize-space(.)), 'memorial collection')">
                                        <note><xsl:value-of select="normalize-space(.)"/></note>
                                    </xsl:when>
                                    <xsl:when test="contains(normalize-space(lower-case(.)), 'publication') or contains(normalize-space(lower-case(.)), 'publisher') or contains(normalize-space(lower-case(.)), 'tichnor') or contains(normalize-space(lower-case(.)), 'dexter press') or contains(normalize-space(lower-case(.)), 'dexter, west hyack') or contains(normalize-space(lower-case(.)), 'colourpicture') or contains(normalize-space(lower-case(.)), 'printing') or contains(normalize-space(lower-case(.)), 'printed by') or contains(normalize-space(lower-case(.)), 'c. t.') or contains(normalize-space(lower-case(.)), 'c.t.')">
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
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:contributor" mode="publisher">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(lower-case(.)), 'publication') or contains(normalize-space(lower-case(.)), 'publisher') or contains(normalize-space(lower-case(.)), 'tichnor') or contains(normalize-space(lower-case(.)), 'dexter press') or contains(normalize-space(lower-case(.)), 'dexter, west hyack') or contains(normalize-space(lower-case(.)), 'colourpicture') or contains(normalize-space(lower-case(.)), 'printing') or contains(normalize-space(lower-case(.)), 'printed by') or contains(normalize-space(lower-case(.)), 'c. t.') or contains(normalize-space(lower-case(.)), 'c.t.')">
                    <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'unknown')) and not(contains(normalize-space(lower-case(.)), 'collection processed'))">
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space(.), 'Copyright')">
                        <note><xsl:value-of select="normalize-space(.)"/></note> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'architect')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), '(architect)', '')"/></namePart>
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
                            <namePart><xsl:value-of select="replace(normalize-space(.), '(Architect)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/arc">Architect</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'associate')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), '(associate)', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Associate</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Associate')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), '(Associate)', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Associate</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Cover Art')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Cover Art by ', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cov">Cover designer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'cover art')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), '(cover art)', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cov">Cover designer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Original portrait')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Original portrait by ', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/art">Artist</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Ektachrome photograph')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Ektachrome photograph by ', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Commercial Photographers.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Commercial Photographers.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Photo by')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), 'Photo by ', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), '(Photographer)')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), '(Photographer)', '')"/></namePart>
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
    
    <xsl:template match="dc:format" mode="genre">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:call-template name="AATgenre">
                    <xsl:with-param name="term"><xsl:value-of select="lower-case(normalize-space(.))"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="shelfLocator">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:if test="contains(lower-case(.), 'box') or contains(lower-case(.), 'drawer') or contains(lower-case(.), 'folder')">
                <shelfLocator><xsl:value-of select="normalize-space(.)"/></shelfLocator>
            </xsl:if>
        </xsl:if>
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
            <recordContentSource>Memphis Public Library</recordContentSource>
            <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
        </recordInfo>
    </xsl:template>
    
    <xsl:template match="dc:relation">
        <!-- ignore - duplicated information -->
    </xsl:template>
    
    <xsl:template match="dc:source">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'collection of collections')) and not(contains(., 'M Files')) and not(contains(., 'Memphis Streetscapes')) and not(contains(., 'Postcards from Memphis')) and not(contains(., 'Library History')) and not(contains(., 'German Heritage')) and not(contains(., 'Mid-South Flood Collection')) and not(contains(., 'Greater Memphis Chamber')) and not(contains(., 'Library of Congress')) and not(contains(., 'MPLIC')) and not(contains(., 'University of North Carolina at Chapel Hill')) and not(contains(., 'Memphis Chamber of Commerce Files')) and not(contains(., 'Memphis City Hall'))">
                <relatedItem type='host' displayLabel='Collection'>
                    <titleInfo>
                        <title><xsl:value-of select="normalize-space(.)"/></title>
                    </titleInfo>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:source" mode="repository">
        <xsl:if test="contains(., 'Library of Congress') or contains(., 'MPLIC') or contains(., 'University of North Carolina at Chapel Hill') or contains(., 'Greater Memphis Chamber') or contains(., 'Memphis City Hall')">
            <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:call-template name="LCSHtopic">
                    <xsl:with-param name="term"><xsl:value-of select="lower-case(normalize-space(.))"/></xsl:with-param>
                </xsl:call-template>
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
