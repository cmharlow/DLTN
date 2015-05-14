<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
        
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <!-- if statement blocks output of TSLA records that are at item/part-level - ends with _#, Part #, Page #, or title is only #-->
        <xsl:if test="not(matches(dc:title/text(), '_\d+$')) or not(matches(dc:title/text(), 'Part \d+$')) or not(matches(dc:title/text(), 'Page \d+$')) or not(matches(dc:title/text(), '^\d+$'))">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title"/> <!-- titleInfo/title and part/detail|date parsed out -->
            
            <xsl:apply-templates select="dc:creator"/> <!-- name -->
            <xsl:apply-templates select="dc:contributor"/> <!-- name -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher" /> <!-- publisher -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:coverage|dc:relation">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- internetMediaTypes -->
                    <xsl:apply-templates select="dc:format" mode="extent"/> <!-- some extent -->
                    <xsl:apply-templates select="dc:coverage" mode="extent"/> <!-- some extent -->
                    <xsl:apply-templates select="dc:relation" mode="form"/> <!-- some forms pulled out -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/>
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:format" mode="itemType"/> <!-- Item Type -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subject - tokenized -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic info -->
            <xsl:apply-templates select="dc:source"/> <!-- mainly collections, some other stuff - unparseable -->
            <xsl:apply-templates select="dc:type"/> <!-- genre -->
            <xsl:apply-templates select="dc:relation"/> <!-- related items? some genre terms. mostly notes because impossible to parse -->
            <recordInfo>
                <recordContentSource>Tennessee State Library and Archives</recordContentSource>
                <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </languageOfCataloging>
                <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using DSpace (data dictionary available: https://wiki.lib.utk.edu/display/DPLA/Crossroads+Mapping+Notes.)</recordOrigin>
            </recordInfo>
        </mods>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:title">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="starts-with(normalize-space(.), 'SSchNno')">
                    <titleInfo>
                        <title>Southern School News</title>
                    </titleInfo>
                    <part>
                        <detail>
                            <number><xsl:value-of select="replace(normalize-space(.), 'SSchNno', 'Number ')"/></number>
                        </detail>
                    </part>
                </xsl:when>
                <xsl:when test="starts-with(normalize-space(.), 'SSchNVol')">
                    <titleInfo>
                        <title>Southern School News</title>
                    </titleInfo>
                    <part>
                        <detail>
                            <number><xsl:value-of select="replace(normalize-space(.), 'SSchNVol', 'Volume ')"/></number>
                        </detail>
                    </part>
                </xsl:when>
                <xsl:when test="starts-with(normalize-space(.), 'SSN ')">
                    <titleInfo>
                        <title>Southern School News</title>
                    </titleInfo>
                    <part>
                        <detail>
                            <number><xsl:value-of select="replace(normalize-space(.), 'SSN ', '')"/></number>
                        </detail>
                    </part>
                </xsl:when>
                <xsl:otherwise>
                    <titleInfo>
                        <title><xsl:value-of select="normalize-space(.)"/></title>
                    </titleInfo>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:contributor">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <name>
                <namePart>
                    <xsl:value-of select="normalize-space(.)"/>
                </namePart>
                <role>
                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/ctb">
                        <xsl:text>Contributor</xsl:text>
                    </roleTerm>
                </role> 
            </name>       
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
        <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='unknown'">
            <xsl:choose>
                <xsl:when test="matches(normalize-space(.), '\d+')">
                    <!-- don't map, handled with extent-->
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Richmond (Va.)')">
                    <subject>
                        <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79060700">Richmond (Va.)</geographic>
                        <cartographics>
                            <coordinates>37.55376, -77.46026</coordinates>
                        </cartographics> 
                    </subject> 
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Chattanooga (Tenn.)')">
                    <subject>
                        <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79075123">Chattanooga (Tenn.)</geographic>
                        <cartographics>
                            <coordinates>35.04563, -85.30968</coordinates>
                        </cartographics> 
                    </subject> 
                </xsl:when>
                <xsl:when test="matches(normalize-space(.), 'Memphis (Tenn.)')">
                    <subject>
                        <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78095779">Memphis (Tenn.)</geographic>
                        <cartographics>
                            <coordinates>35.14953, -90.04898</coordinates>
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
                <xsl:when test="matches(normalize-space(.), 'McMinnville (Tenn.)')">
                    <subject>
                        <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n96046228">McMinnville (Tenn.)</geographic>
                        <cartographics>
                            <coordinates>35.6834, -85.76998</coordinates>
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
    </xsl:template>
    
    <xsl:template match="dc:coverage" mode="extent">
        <xsl:if test="matches(normalize-space(.), '\d+')">
            <extent><xsl:value-of select="normalize-space(.)"/></extent>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:creator">
        <xsl:if test="normalize-space(.)!='' and lower-case(normalize-space(.)) != 'n/a'">
            <name>
                <namePart>
                    <xsl:value-of select="normalize-space(.)"/>
                </namePart>
                <role>
                    <roleTerm type="text" valueURI="http://id.loc.gov/vocabulary/relators/cre">
                        <xsl:text>Creator</xsl:text>
                    </roleTerm>
                </role> 
            </name>       
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:date"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='unknown' and normalize-space(lower-case(.))!='undated'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}$') or matches(normalize-space(.), '^\d{4}-\d{2}$') or matches(normalize-space(.), '^\d{4}-\d{2}-\d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="."/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^\d{4}-\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(.), '-', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- Text Terms -->
                    <xsl:when test="normalize-space(lower-case(.))='pre civil war' or normalize-space(lower-case(.))='pre-civil war' or normalize-space(lower-case(.))='antebellum'">
                        <dateCreated encoding="edtf" keyDate="yes">unknown/1861</dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="normalize-space(lower-case(.))='postwar' or normalize-space(lower-case(.))='post-civil war' or normalize-space(lower-case(.))='postbellum'">
                        <dateCreated encoding="edtf" keyDate="yes">1865/unknown</dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- Match Month YYYY formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^january \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-01')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^february \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-02')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^march \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-03')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^april \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-04')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^may \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-05')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^june \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-06')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^july \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-07')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^august \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-08')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^september \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-09')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^october \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-10')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^november \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-11')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^december \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(lower-case(.)), ' ')), '-12')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- CIRCA or APPROXIMATE or ABOUT or PROBABLY YYYY -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^circa \d{4}$') or matches(lower-case(normalize-space(.)), '^ca. \d{4}$') or matches(lower-case(normalize-space(.)), '^approximately \d{4}$') or matches(lower-case(normalize-space(.)), '^about \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="normalize-space(substring-after(normalize-space(.), ' '))"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^circa \d{4}\d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes" qualifier="approximate"><xsl:value-of select="replace(normalize-space(substring-after(normalize-space(.), ' ')), '-', '/')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space(.)), 'circa')">
                        <dateCreated qualifier="approximate"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space(.)), 'probably')">
                        <dateCreated qualifier="questionable"><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- BEFORE YYYY or AFTER YYYY -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^before \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat('unknown/', normalize-space(substring-after(normalize-space(.), ' ')))"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^after \d{4}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="concat(normalize-space(substring-after(normalize-space(.), ' ')), '/unknown')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                <!-- Match YYYY Month DD formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} january \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' january ', '-01-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} january \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' january ', '-01-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} february \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' february ', '-02-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} february \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' february ', '-02-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} march \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' march ', '-03-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} march \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' march ', '-03-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} april \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' april ', '-04-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} april \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' april ', '-04-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} may \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' may ', '-05-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} may \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' may ', '-05-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} june \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' june ', '-06-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} june \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' june ', '-06-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} july \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' july ', '-07-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} july \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' july ', '-07-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} august \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' august ', '-08-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} august \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' august ', '-08-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} september \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' september ', '-09-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} september \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' september ', '-09-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} october \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' october ', '-10-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} october \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' october ', '-10-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} november \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' november ', '-11-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} november \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' november ', '-11-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} december \d{2}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' december ', '-12-')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} december \d{1}$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' december ', '-12-0')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
            <!-- Match YYYY Month formatting -->
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} january$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' january ', '-01')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} february$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' february ', '-02')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} march$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' march ', '-03')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} april$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' april ', '-04')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} may$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' may ', '-05')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} june$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' june ', '-06')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} july$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' july ', '-07')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} august$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' august ', '-08')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} september$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' september ', '-09')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} october$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' october ', '-10')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} november$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' november ', '-11')"/></dateCreated>
                        <dateCreated><xsl:value-of select="normalize-space(.)"/></dateCreated>
                    </xsl:when>
                    <xsl:when test="matches(lower-case(normalize-space(.)), '^\d{4} december$')">
                        <dateCreated encoding="edtf" keyDate="yes"><xsl:value-of select="replace(normalize-space(lower-case(.)), ' december ', '-12')"/></dateCreated>
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
        <xsl:if test="normalize-space(.)!=''">
            <abstract><xsl:value-of select="normalize-space(.)"/></abstract>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:format">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'audio/wav')">
                        <internetMediaType>audio/wav</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image/jp2')">
                        <internetMediaType>image/jp2</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image/jpeg') or matches(normalize-space(lower-case(.)), 'image/jpg') or matches(normalize-space(lower-case(.)), 'jpg') or matches(normalize-space(lower-case(.)), 'jpeg')">
                        <internetMediaType>image/jpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'mp3')">
                        <internetMediaType>audio/mp3</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'mpeg')">
                        <internetMediaType>audio/mpeg</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'tiff')">
                        <internetMediaType>image/tiff</internetMediaType>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'wmv')">
                        <internetMediaType>video/wmv</internetMediaType>
                    </xsl:when>
                    <xsl:otherwise>
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
        
    <xsl:template match="dc:format" mode="extent"> 
        <xsl:if test="matches(normalize-space(.), '\d+') and not(contains(lower-case(.), 'jp2')) and not(contains(lower-case(.), 'mp3'))">
            <extent><xsl:value-of select="normalize-space(.)"/></extent>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="itemType"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'audio/wav') or matches(normalize-space(lower-case(.)), 'mpeg') or matches(normalize-space(lower-case(.)), 'mp3')">
                        <typeOfResource>sound recording</typeOfResource>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'image') or matches(normalize-space(lower-case(.)), 'tiff') or matches(normalize-space(lower-case(.)), 'image/jp2') or matches(normalize-space(lower-case(.)), 'image/jpeg') or matches(normalize-space(lower-case(.)), 'image/jpg') or matches(normalize-space(lower-case(.)), 'jpg') or matches(normalize-space(lower-case(.)), 'jpeg')">
                        <typeOfResource>still image</typeOfResource>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'wmv')">
                        <typeOfResource>moving image</typeOfResource>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'text') or matches(normalize-space(lower-case(.)), 'scanned')">
                        <typeOfResource>text</typeOfResource>
                    </xsl:when>
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
            <!-- process identifier into CONTENTdm 6.5 thumbnail urls --> 
            <xsl:variable name="contentdmroot" select="substring-before($idvalue,'/cdm/ref/')"/>
            <xsl:variable name="recordinfo" select="substring-after($idvalue,'/cdm/ref/collection/')"/>
            <xsl:variable name="alias" select="substring-before($recordinfo,'/id/')"/>
            <xsl:variable name="pointer" select="substring-after($recordinfo,'/id/')"/>
            <url access="preview"><xsl:value-of select="concat($contentdmroot,'/utils/getthumbnail/collection/',$alias,'/id/',$pointer)"/></url> <!--CONTENTdm thumbnail url-->
            <!-- end CONTENTdm thumbnail url processing -->           
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:publisher">
        <xsl:if test="normalize-space(.)!=''">
            <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:relation"> <!-- mix of notes, related item ids, related item URLs, and form/genre terms -->
        <xsl:if test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)),'tennessee state library')">
            <xsl:choose>
                <xsl:when test="starts-with(normalize-space(lower-case(.)), 'http') or starts-with(normalize-space(lower-case(.)), 'ttp') or starts-with(normalize-space(lower-case(.)), 'www')">
                    <relatedItem>
                        <location>
                            <url><xsl:value-of select="normalize-space(.)"/></url>
                        </location>
                    </relatedItem>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'composite')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300134769">composite photographs</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'contact print')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127169">contact prints</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'copy print')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300188795">copy prints</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'photographic print')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127104">photographic prints</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'political cartoon')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300123224">political cartoons</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'printed postcard')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'real photo postcard')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300192703">photographic postcards</genre>
                </xsl:when> 
                <xsl:otherwise>
                    <note><xsl:value-of select="normalize-space(.)"/></note><!-- would like to parse out notes versus related item identifiers, but no easy way to do so. CMH 5/12/2015 -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:relation" mode="form"> <!-- form terms -->
        <xsl:if test="normalize-space(.)!='' and starts-with(normalize-space(lower-case(.)),'tennessee state library')">
            <xsl:choose>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'composite')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'contact print')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'copy print')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'photographic print')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'political cartoon')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'printed postcard')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when> 
                <xsl:when test="matches(normalize-space(lower-case(.)), 'real photo postcard')">
                    <form><xsl:value-of select="normalize-space(lower-case(.))"/></form>
                </xsl:when>
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
    
    <xsl:template match="dc:source">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'collection') or contains(normalize-space(lower-case(.)), 'papers') or contains(normalize-space(lower-case(.)), 'records')">
                    <relatedItem type="host" displayLabel="Collection">
                        <titleInfo>
                            <title><xsl:value-of select="normalize-space(.)"/></title>
                        </titleInfo>
                    </relatedItem>
                </xsl:when>
                <xsl:otherwise>
                    <relatedItem type="host">
                        <titleInfo>
                            <title><xsl:value-of select="normalize-space(.)"/></title>
                        </titleInfo>
                    </relatedItem>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:if>
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
                <xsl:when test="contains(normalize-space(lower-case(.)), 'map')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
                    <typeOfResource>cartographic</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'manuscripts')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028569">manuscripts (document genre)</genre>
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'audio') or contains(normalize-space(lower-case(.)), 'sound')">
                    <typeOfResource>sound recording</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'object')">
                    <typeOfResource>three dimensional object</typeOfResource>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'video')">
                    <typeOfResource>moving image</typeOfResource>
                </xsl:when>
                <xsl:when test="matches(normalize-space(lower-case(.)), 'text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
