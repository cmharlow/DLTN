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
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic, temporal subject info -->
            <xsl:apply-templates select="dc:format" mode="genre"/>
            <xsl:apply-templates select="dc:type"/> <!-- item types -->
            <xsl:apply-templates select="dc:source"/>
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Manuscript Collection Finding Aids</title>
                </titleInfo>
                <abstract>This collection serves as an index of all of the processed manuscript collections in the Memphis & Shelby County Room. The bulk of the information about these collections is from the Guide to the Processed Manuscript Collections in the Memphis and Shelby County Room, written and compiled by our very own Gina Cordell.</abstract>
                <location>
                    <url>http://cdm16108.contentdm.oclc.org/cdm/landingpage/collection/p13039coll1</url>
                </location>
            </relatedItem>
            <recordInfo>
                <recordContentSource>Memphis-Shelby County Public Library and Information Center</recordContentSource>
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
                    <xsl:when test="contains(normalize-space(.), 'digitized by')">
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
                        <note type="ownership"><xsl:value-of select="normalize-space(.)"/></note>
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
    
    <xsl:template match="dc:coverage"> <!-- Subject headings/Geographic Names present, but uniquely formulated - can't currently parse -->
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='n/a'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}s$') or matches(normalize-space(.), '^\d{4}s to \d{4}s$')">
                        <subject>
                            <temporal><xsl:value-of select="."/></temporal>
                        </subject>
                    </xsl:when>
                    <xsl:otherwise>
                        <subject>
                            <topic><xsl:value-of select="normalize-space(.)"/></topic>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(contains(normalize-space(lower-case(.)), 'unknown')) and not(contains(normalize-space(lower-case(.)), 'collection processed'))">
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space(.), 'Copyright')">
                        <note type="ownership"><xsl:value-of select="normalize-space(.)"/></note> 
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
                <!-- QUESTIONABLE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '?')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\?{4}-\d{2}-\?{2}$') or matches(normalize-space(.), '^\?{4}-\d{2}$') or matches(normalize-space(.), '^\?{4}-\d{2}-\d{2}$')">
                                <dateCreated encoding="edtf" qualifier="questionable" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '\?', 'u')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2} (\?)$')">
                                <dateCreated encoding="edtf" qualifier="questionable" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' (\?)', '')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\?{4}-\d{2}-\?{2} \[.+\]$') or matches(normalize-space(.), '^\d{2}\?{2}-\d{2}-\?{2} \[.+\]$') or matches(normalize-space(.), '^\?{4}-\d{2} \[.+\]$') or matches(normalize-space(.), '^\?{4}-\d{2}-\d{2} \[.+\]$')">
                                <dateCreated encoding="edtf" qualifier="questionable" keyDate="yes"><xsl:value-of select="substring-before(replace(normalize-space(.), '\?', 'u'), '[')"/></dateCreated>
                                <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="questionable"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                <!-- REVISIONS -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4} \(.+\)$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="substring-before(normalize-space(.), ' \(')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
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
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(., '.+\d+.+') or contains(., 'one') or contains(., 'two') or contains(., 'three') or contains(., 'four') or contains(., 'five') or contains(., 'six') or contains(., 'seven')  or contains(., 'eight') or contains(., 'nine') or contains(., 'ten') or contains(., 'eleven') or contains(., 'twelve') or contains(., 'thirteen') or contains(., 'fourteen') or contains(., 'fifteen') or contains(., 'sixteen') or contains(., 'seventeen') or contains(., 'eighteen') or contains(., 'nineteen')">
                        <xsl:choose>
                            <xsl:when test="contains(., 'jpeg') or contains(., 'jpg') or contains(., 'mp3') or contains(., 'mp4') or contains(., 'pdf') or contains(., 'vhs')">
                                <xsl:for-each select="tokenize(., ', ')">
                                    <xsl:if test="normalize-space(.)!=''">
                                        <xsl:choose>
                                            <xsl:when test="contains(., 'jpeg') or contains(., 'jpg')">
                                                <internetMediaType>image/jpeg</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'mp3')">
                                                <internetMediaType>audio/mp3</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'mp4')">
                                                <internetMediaType>audio/mp4</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'pdf')">
                                                <internetMediaType>application/pdf</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'vhs')">
                                                <internetMediaType>video/vhs</internetMediaType>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <extent><xsl:value-of select="."/></extent>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="matches(., '^\D+, .+$')">
                                <xsl:for-each select="tokenize(., ', ')">
                                    <xsl:if test="normalize-space(.)!=''">
                                        <xsl:choose>
                                            <xsl:when test="matches(., '.+\d+.+') or contains(., 'one') or contains(., 'two') or contains(., 'three') or contains(., 'four') or contains(., 'five') or contains(., 'six') or contains(., 'seven')  or contains(., 'eight') or contains(., 'nine') or contains(., 'ten') or contains(., 'eleven') or contains(., 'twelve') or contains(., 'thirteen') or contains(., 'fourteen') or contains(., 'fifteen') or contains(., 'sixteen') or contains(., 'seventeen') or contains(., 'eighteen') or contains(., 'nineteen')">
                                                <extent><xsl:value-of select="."/></extent>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <form><xsl:value-of select="."/></form>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <extent><xsl:value-of select="."/></extent>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains(., 'jpeg') or contains(., 'jpg') or contains(., 'mp3') or contains(., 'mp4') or contains(., 'pdf') or contains(., 'vhs')">
                                <xsl:for-each select="tokenize(., ', ')">
                                    <xsl:if test="normalize-space(.)!=''">
                                        <xsl:choose>
                                            <xsl:when test="contains(., 'jpeg') or contains(., 'jpg')">
                                                <internetMediaType>image/jpeg</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'mp3')">
                                                <internetMediaType>audio/mp3</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'mp4')">
                                                <internetMediaType>audio/mp4</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'pdf')">
                                                <internetMediaType>application/pdf</internetMediaType>
                                            </xsl:when>
                                            <xsl:when test="contains(., 'vhs')">
                                                <internetMediaType>video/vhs</internetMediaType>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <note><xsl:value-of select="."/></note>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <form><xsl:value-of select="."/></form>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="genre">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(lower-case(.)), 'abstract')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026032">abstracts (summaries)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'account book')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027483">account books</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'account')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300145802">accounts</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'address book')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026689">address books</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'affidavit')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027594">affidavits</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'advertisement') or matches(normalize-space(lower-case(.)), 'ads') ">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193993">advertisements</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'agenda')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027426">agendas (administrative records)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'album')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026690">albums (books)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'application')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300312189">applications</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'appointment book')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026710">appointment books</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'apron')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046131">aprons (protective wear)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'architectural drawing')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300034787">architectural drawings (visual works)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'armband')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300247490">armbands</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'article')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300048715">articles</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'audit')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027475">audits</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'autograph')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028571">autographs (manuscripts)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'award')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026842">awards</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'badge')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193994">badges</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'ballot')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027428">ballots</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'bible')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264513">Bibles</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'bibliograph')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026497">bibliographies</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'autobiograph')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080104">autobiographies</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'biograph')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080102">biographies (documents)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'book')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'booklet')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311670">booklets</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'brochure')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300248280">brochures</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'clipping')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026867">clippings (information artifacts)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'computer disk')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300266292">hard disks</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'correspondence')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026877">correspondence</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'directory')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026234">directories</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'drawings')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033973">drawings (visual works)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'ephemera')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028881">ephemera (general)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'fieldnotes')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027201">field notes</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'film')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300014637">film (material by form)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'government publication')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027777">government records</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'handbook')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311807">handbooks</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'image')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'index')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026554">indexes (reference sources)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'instruction')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027042">instructions (document genre)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'interview')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'invitation')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027083">invitations</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'leaflet')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300211825">leaflets (printed works)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'legal case and case notes')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'map')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'memoir')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202559">memoirs</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'newspaper')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'oral history')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202595">oral histories (document genres)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'painting')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033618">paintings (visual works)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'pamphlet')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'paper')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300199056">papers (document genres)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'periodical')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026657">periodicals</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'photograph')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'portrait')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015637">portraits</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'postcard')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'poster')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'program')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'report')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'slide')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128371">slides (photographs)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'speech')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026671">speeches (documents)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'survey')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300226986">surveys (documents)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'technical report')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027323">technical reports</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'text')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
                </xsl:if>
                <xsl:if test="contains(normalize-space(lower-case(.)), 'thesis')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028028">theses</genre>
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
                            <xsl:when test="starts-with(normalize-space(lower-case(.)), 'fre')">
                                <languageTerm type="code" authority="iso639-2b">fre</languageTerm>
                            </xsl:when>
                            <xsl:when test="normalize-space(lower-case(.))='ger'">
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
