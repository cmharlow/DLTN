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
    
    <!-- OAI-DC to MODS Middle Tennessee State University Institution-Level Transformations. Includes the following templates:
        dc:contributor
        dc:contributor mode=repository
        dc:creator
        dc:creator mode=repository
        dc:format
        dc:publisher (left at institution level to remove/block institution that digitized as publisher)
        dc:publisher mode=repository
        recordInfo (static value for all MTSU collections)
        dc:relation
        dc:source
        dc:subject
        dc:type
        dc:type mode=MIME
        dc:type mode=form
    -->
    
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
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'bus. mgr')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', bus. mgr.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Business manager</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'mgr')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', mgr.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Manager</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'ed.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'eds.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', eds.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'speaker')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', speaker', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/spk">Speaker</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', interviewer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photo. ed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photo. ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Photographic editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'recorder')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', recorder', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/rcd">Recordist</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'asst. ed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', asst. ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'illustrator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', illustrator', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ill">Illustrator</roleTerm>
                            </role>  
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'performer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', performer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/prf">Performer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'asst. dir')">
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
                    <xsl:when test="contains(normalize-space(.), 'editor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', editor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'assoc. ed')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', assoc. ed.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role>   
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'faculty advisor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', faculty advisor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ths">Thesis advisor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'advisor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', advisor', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Advisor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
                            </role> 
                        </name>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'collaborator')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', collaborator', '')"/></namePart>
                            <role>
                                <roleTerm type="text">Collaborator</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">Contributor</roleTerm>
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
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'architect')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', architect', '')"/></namePart>
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
                    <xsl:when test="contains(normalize-space(.), 'cartographer and engraver')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', cartographer and engraver', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctg">Cartographer</roleTerm>
                            </role>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">Engraver</roleTerm>
                            </role>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'editor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', editor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/edt">Editor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'compiler')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', compiler', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/com">Compiler</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'engravers')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', engravers', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">Engraver</roleTerm>
                            </role>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'engraver')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', engraver', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/egr">Engraver</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), ',interviewee')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ',interviewee', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ive">Interviewee</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'interviewee')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', interviewee', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ive">Interviewee</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', interviewer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Interviewer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Interviewer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ivr">Interviewer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'map')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', map', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctg">Cartographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Photographers')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', Photographers', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer.')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer.', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photographer')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photographer', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'photograph')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', photograph', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/pht">Photographer</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'sculptor')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', sculptor', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/scl">Sculptor</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
                            </role>
                        </name> 
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'text')">
                        <name>
                            <namePart><xsl:value-of select="replace(normalize-space(.), ', text', '')"/></namePart>
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/aut">Author</roleTerm>
                            </role> 
                            <role>
                                <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">Creator</roleTerm>
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
                <physicalLocation><xsl:value-of select="replace(normalize-space(.), ' (Publisher)', '')"/></physicalLocation>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="genre">
        <xsl:for-each select="tokenize(., ';')">
            <xsl:for-each select="tokenize(replace(normalize-space(.), '\)', ''), '\(')">
                <xsl:if test="normalize-space(.)!=''">
                    <xsl:call-template name="AATgenre">
                        <xsl:with-param name="term"><xsl:value-of select="lower-case(normalize-space(.))"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and not(matches(., 'Murfreesboro, TN')) and not(contains(normalize-space(lower-case(.)), 'albert gore')) and not(contains(normalize-space(lower-case(.)), 'arts center')) and not(contains(normalize-space(lower-case(.)), 'center for historic preservation')) and not(contains(normalize-space(lower-case(.)), 'james e. walker library')) and not(contains(normalize-space(lower-case(.)), 'tennessee state library'))">
                <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
            </xsl:if>
            <xsl:if test="matches(., 'Murfreesboro, TN')">
                <place><xsl:value-of select="."/></place>
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
    
    <xsl:template name="recordSource">
        <!--
      	weird issue(s?) with the logic in the following xsl:if; specific to the in-REPOX transform, i.e. works fine externally
      	using the saxon-8.7.jar. leaving the original commented for now.
      -->
        <!--<xsl:if
							test="
									(count(dc:publisher) >= 2) and
									(some $pub in dc:publisher
											satisfies not(matches(., 'Digital Initiatives, James E. Walker Library, Middle Tennessee State University')))">-->
        <xsl:if test="count(dc:publisher) >= 2">
            <note displayLabel="Intermediate Provider">Digital Initiatives, James E. Walker Library,
                Middle Tennessee State University</note>
        </xsl:if>
        <!--</xsl:if>-->
        <recordInfo>
            <xsl:variable name="pub-count" select="count(dc:publisher)"/>
            <xsl:for-each select="dc:publisher">
                <xsl:choose>
                    <xsl:when test=".[starts-with(., 'Digital Initiatives')] and $pub-count = 1">
                        <recordContentSource>
                            <xsl:value-of select="."/>
                        </recordContentSource>
                    </xsl:when>
                    <xsl:when test=".[not(contains(normalize-space(.), 'Digital Initiatives'))] and $pub-count > 1">
                        <recordContentSource>
                            <xsl:value-of select=".[not(contains(normalize-space(.), 'Digitial Initiatives'))]"/>
                        </recordContentSource>
                    </xsl:when>
                    <xsl:when test="$pub-count = 1">
                        <recordContentSource>
                            <xsl:value-of select="."/>
                        </recordContentSource>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:if test="count(dc:publisher) = 0">
                <recordContentSource>Digital Initiatives, James E. Walker Library, Middle Tennessee State University</recordContentSource>
            </xsl:if>
            <recordChangeDate>
                <xsl:value-of select="current-date()"/>
            </recordChangeDate>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core
                record by the Digital Library of Tennessee, a service hub of the Digital Public
                Library of America, using a stylesheet available at https://github.com/utkdigitalinitiatives/DLTN.
                Metadata originally created in a locally modified version of qualified Dublin Core
                using ContentDM (data dictionary available:
                https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
        </recordInfo>
    </xsl:template>
    
    <xsl:template match="dc:relation">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="starts-with(.,'http')"> 
                        <relatedItem>
                            <location>
                                <url><xsl:value-of select="normalize-space(.)"/></url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(.,'All rights reserved') or contains(.,'Courtesy of')"> 
                        <accessCondition type='local rights statement'><xsl:value-of select="normalize-space(.)"/></accessCondition>
                    </xsl:when>
                    <xsl:when test="contains(.,', photographer')"> 
                        <name>
                            <namePart><xsl:value-of select="normalize-space(.)"/></namePart>
                        </name>
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
                <xsl:call-template name="LCSHtopic">
                    <xsl:with-param name="term"><xsl:value-of select="lower-case(normalize-space(replace(., ' -- ', '--')))"/></xsl:with-param>
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
    
    <xsl:template match="dc:type" mode="form">
        <!-- do nothing for time being -->
    </xsl:template>
    
</xsl:stylesheet>
