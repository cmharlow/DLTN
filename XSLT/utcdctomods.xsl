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
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher"/> <!-- place of origin and publishers -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:publisher|dc:identifier"></xsl:if>
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
                <recordContentSource>University of Tennessee, Chattanooga. Library</recordContentSource>
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
                <xsl:if test="not(contains(normalize-space(.), 'University of Tennessee at Chattanooga'))">
                    <publisher><xsl:value-of select="normalize-space(.)"/></publisher>
                </xsl:if>
                <xsl:if test="matches(normalize-space(.), 'Chattanooga (Tenn.)')">
                    <place><xsl:value-of select="normalize-space(.)"/></place>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:publisher" mode="repository"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:if test="contains(normalize-space(.), 'University of Tennessee at Chattanooga')">
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
                    <xsl:when test="contains(normalize-space(.), 'University of Tennessee at Chattanooga Echo Student Newspapers')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The University of Tennessee at Chattanooga Echo Student Newspapers digital collection features the issues of newspapers produced by university students from 1888 to 1976. The University Lookout, a precursor to the University Echo, is part literary magazine and part student newspaper and it is also included in this digital collection.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll9</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Raymond B. Witt Chattanooga Public Schools Desegregation records')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Raymond B. Witt Chattanooga Public Schools Desegregation Records digital collection documents Chattanooga's response to the United States Supreme Court decision in Brown v. Board of Education of Topeka that ruled segregation in public schools unconstitutional in 1955. As chair and member of the Chattanooga Board of Education and as the chief attorney for the defendant in the 1960 case, Mapp v. Board of Education of Chattanooga, in which the NAACP supported the case of James Jonathan Mapp to force public school integration in Chattanooga, Raymond B. Witt amassed legal documents, correspondence, meeting minutes, and other records created by the Board of Education, the United States District Court, and many citizens of Chattanooga....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll8</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Penelope Johnson Allen Brainerd Mission correspondence and photographs')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Penelope Johnson Allen Brainerd Mission Correspondence and Photographs digital collection features orignal correspondence and receipts created by the United States Department of War, Indian Agent Return J. Meigs, and Brainerd Mission superintendents and founders Gideon Blackburn, Cyrus Kingsbury, and Ard Hoyt. The collection also includes photographs of portraits of the Brainerd missionaries, Daughters of the American Revolution dedication events at Brainerd Mission Cemetery, and copies of etchings of Brainerd Mission. Inspired by the history of John Ross, the Cherokee Nation, and the Trail of Tears, Chattanooga native Penelope Johnson Allen devoted much of her free time to learning more about the history of the Cherokee Indians, including Brainerd Mission, a Christian mission to the Cherokee located in Chattanooga, Tennessee that was created by the American Board of Commissioners for Foreign Missions in 1817. Allen collected books and original documents created by the United States Department of War Indian Agent, Return J. Meigs, as well as missionaries to the Cherokee, Gideon Blackburn, Cyrus Kingsbury, and Ard Hoyt who were responsible for the creation and development of Brainerd Mission. In addition to the correspondence and photographs featured in this digital collection, the Penelope Johnson Allen Research Notes and Correspondence manuscript collection documents the preservation and memorialization of the Brainerd Mission Cemetery through the efforts of the Daughters of the American Revolution.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll7</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Emma Bell Miles Southern Appalachia art and correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Emma Bell Miles Southern Appalachia art and correspondence digital collection contains correspondence among members and friends of writer and artist Emma Bell Miles’ family of origin illustrating the personal roots of themes Emma lived out and developed in her work. The heart of the collection is a series of letters written during 1901-1903 concerning Emma’s troubled relationship with her parents, her life as a young woman, and her life as an emerging artist and naturalist; as well as the death of her mother, Emma’s marriage to Frank Miles soon thereafter, and disposition of Bell family property in Walden Ridge, Tennessee. The collection also features numerous examples of Emma's art, including watercolors, oil paintings, and sketches....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll6</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Leroy M. Sullivan World War II diaries and correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Leroy M. Sullivan World War II Diaries and Correspondence digital collection features three diaries and sixteen letters authored by Leroy M. Sullivan, a Flight Lieutenant in the Royal Canadian Air Force, during World War II from 1940 to 1943, when Sullivan was killed in action. The diaries document Lieutenant Sullivan's participation in campaigns in England, South Africa, Sudan, and Egypt, and the letters to Sullivan's friend, Grady Long, detail daily life in the military, especially the ways in which he and his fellow soldiers spent their time between operations. Leroy M. Sullivan was a University of Chattanooga student who joined the Royal Canadian Air Force in 1941 and was killed in action in 1943. He quickly rose to the rank of Flight Lieutenant and was a commanding officer of his squadron during a portion of his time in Africa. He was the only American member of the British Royal Air Force, No. 56, Punjab Squadron, created under Article XV of the British Commonwealth Air Training Plan, which allowed the air forces of Australia, Canada and New Zealand to form squadrons for service under Royal Air Force operational control....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll5</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Lula Ulrica Whitaker Southern Agrarian Writers correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Lula Ulrica Whitaker Southern Agrarian Writers Correspondence digital collection contains correspondence from nine of the authors known as the Twelve Southerners. The correspondence, written in 1934, describes each author's understanding of the Southern Agrarian movement....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll4</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'University of Tennessee at Chattanooga Moccasin')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The University of Tennessee at Chattanooga Moccasin Yearbooks digital collection features all 63 volumes of the the Moccasin ranging from 1911 to 1991. Published by students enrolled at the University of Chattanooga (1907-1969) and the University of Tennessee at Chattanooga (1969-present), the Moccasin documents athletics, social functions, and the physical plant, including sections dedicated to student organizations, administrators, academic departments, and more....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll3</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Ralph W. Hood and W. Paul Williamson Holiness Churches of Appalachia')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Ralph W. Hood and W. Paul Williamson Holiness Churches of Appalachia Recordings and Interviews digital collection features a small sample of more than 400 hours of church services and interviews documenting contemporary serpent handlers of Southern Appalachia. Ranging from 1975 to 2004, this collection focuses on the major Pentecostal congregations that practice speaking in tongues, imbibing poisons, and serpent handling in the southeastern United States. For over 20 years, Professors Ralph W. Hood and W. Paul Williamson spent time observing, researching, and engaging in fellowship with believers in the serpent handling tradition....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll2</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'John T. Wilder Civil War correspondence and papers')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The John T. Wilder Civil War Correspondence and Papers digital collection contains correspondence and military records regarding Brigadier General Wilder's service in the Union Army during the American Civil War from 1861-1865 as well as personal correspondence and papers dating from 1865 to 1937. John T. Wilder was born in Hunter, New York, but began his career as an industrialist in Ohio and Indiana. At the outbreak of the United States Civil War, Wilder closed his foundry in Greensburg, Indiana and enlisted in the United States Army Indiana Infantry Regiment. Because of his leadership skills he was consistently promoted, eventually commanding the 17th Indiana Infantry Regiment as a Lieutenant Colonel. During the war he served in Virginia, Kentucky, Georgia, and Tennessee. Wilder was among the first officers to mount his troops and to supply them with Spencer Repeating Rifles, which they used to great effect in the Battle of Chickamauga in Georgia....</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll1</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
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
