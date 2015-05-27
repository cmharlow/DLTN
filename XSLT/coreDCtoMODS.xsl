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
            <xsl:apply-templates select="dc:date"/> <!-- dateCreated -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract/note -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            <xsl:apply-templates select="dc:language"/> <!-- language -->
            
            <location>
                <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context -->
                <xsl:apply-templates select="dc:identifier" mode="locationurl"/> <!-- ContentDM thumbnail -->
            </location>
            
            <originInfo>
                <xsl:apply-templates select="dc:publisher" /> <!-- publisher -->
            </originInfo>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:date"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='unknown' and normalize-space(lower-case(.))!='uknown'">
                <xsl:choose>
                    <!-- DIRECT EDTF MATCHES -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></dateCreated>
                    </xsl:when>
                    <!-- DATE RANGES -->
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{2}-\d{2} to \d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' to ', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4} - \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), ' - ', '/')"/></dateCreated>
                    </xsl:when>
                    <!-- Match Month YYYY formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^january \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-01')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^february \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-02')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^march \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-03')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^april \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-04')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^may \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-05')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^june \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-06')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^july \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-07')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^august \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-08')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^september \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-09')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^october \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-10')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^november \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-11')"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^december \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-12')"/></dateCreated>
                    </xsl:when>
                    <!-- INFERRED -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '\[')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}-\d{2}-\d{2}\]$') or matches(normalize-space(.), '^\[\d{4}-\d{2}\]$') or matches(normalize-space(.), '^\[\d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="translate(normalize-space(.), '\[\]', '')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^\[\d{4}\]\?$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="translate(normalize-space(.), '\[\]', '')"/></dateCreated>
                            </xsl:when>
                            <!-- Match [Month YYYY] formatting -->
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[january \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-01')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[february \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-02')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[march \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-03')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[april \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-04')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[may \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-05')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[june \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-06')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[july \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-07')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[august \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-08')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[september \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-09')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[october \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-10')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[november \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-11')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(lower-case(normalize-space(.)), '^\[december \d{4}\]$')">
                                <dateCreated encoding="edtf" qualifier="inferred" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(lower-case(translate(normalize-space(.), '\[\]', '')), ' ')), '-12')"/></dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated qualifier="inferred"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- QUESTIONABLE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), '?')">
                        <dateCreated qualifier="questionable"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <!-- APPROXIMATE -->
                    <xsl:when test="contains(normalize-space(lower-case(.)), 'circa') or contains(normalize-space(lower-case(.)), 'c.') or contains(normalize-space(lower-case(.)), 'ca.')">
                        <xsl:choose>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}$') or matches(normalize-space(.), '^c. \d{4}-\d{2}$') or matches(normalize-space(.), '^c. \d{4}-\d{2}-\d{2}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c. ', ''), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}-\d{4}$')">
                                <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="concat(concat(concat(substring(normalize-space(.),1, 4),'/'), substring(., 6, 8)), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^ca. \d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'ca. ', ''), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c.\d{4}$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(replace(normalize-space(.), 'c.', ''), '~')"/></dateCreated>
                            </xsl:when>
                            <xsl:when test="matches(normalize-space(.), '^c. \d{4}s$')">
                                <dateCreated encoding="edtf" qualifier="approximate" keyDate="yes"><xsl:value-of select="concat(concat(concat(replace(replace(normalize-space(.), 'c. ', ''), 's', ''), '~'), '/'), concat(replace(replace(normalize-space(.), 'c. ', ''), '0s', '9'), '~'))"/></dateCreated>
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
    
    <xsl:template match="dc:identifier">
        <xsl:if test="normalize-space(.)!='' and not(starts-with(., 'http://'))">
            <identifier><xsl:value-of select="normalize-space(.)"/></identifier>
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
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <xsl:for-each select="tokenize(normalize-space(lower-case(.)), ';')">
            <xsl:for-each select="tokenize(normalize-space(.), ' &amp; ')">
                <xsl:if test="normalize-space(.)!=''">
                    <language>
                        <xsl:choose>
                            <xsl:when test="contains(normalize-space(lower-case(.)), 'english') or contains(normalize-space(lower-case(.)), 'englsih')">
                                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                            </xsl:when>
                            <xsl:when test="contains(normalize-space(lower-case(.)), 'dutch')">
                                <languageTerm type="code" authority="iso639-2b">dut</languageTerm>
                            </xsl:when>
                            <xsl:when test="contains(normalize-space(lower-case(.)), 'french')">
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
    
    <xsl:template match="dc:title">
        <xsl:if test="normalize-space(.)!=''">
            <titleInfo>
                <title><xsl:value-of select="normalize-space(.)"/></title>
            </titleInfo>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>