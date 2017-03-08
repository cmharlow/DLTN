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

    <!-- UTC collections are structured such that they use the relation element consistently/only for sets, so just an institution level record is needed -->

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

            <xsl:if test="dc:publisher|dc:identifier">
                <location>
                    <xsl:apply-templates select="dc:publisher" mode="repository"/>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"></xsl:apply-templates>
                </location>
            </xsl:if>

            <xsl:call-template name="langRepair"/> <!-- language -->
            <xsl:apply-templates select="dc:description"/> <!-- abstract -->
            <xsl:apply-templates select="dc:relation" /> <!-- collections -->
            <xsl:call-template name="rightsRepair"/> <!-- accessCondition, not all records have rights statements -->
            <xsl:apply-templates select="dc:subject"/> <!-- subjects -->
            <xsl:apply-templates select="dc:coverage"/> <!-- geographic subject info -->
            <xsl:apply-templates select="dc:type"/> <!-- genre -->
            <xsl:apply-templates select="dc:type" mode="type"/> <!-- item types -->
            <recordInfo>
                <recordContentSource>University of Tennessee at Chattanooga</recordContentSource>
                <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </languageOfCataloging>
                <recordOrigin>Record has been transformed into MODS 3.5 from a qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/cmh2166/DLTN. Metadata originally created in a locally modified version of qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA.)</recordOrigin>
            </recordInfo>
        </mods>
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
                <xsl:call-template name="SpatialTopic">
                    <xsl:with-param name="term"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>
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

    <xsl:template name="langRepair">
        <xsl:for-each select="dc:language">
            <xsl:choose>
                <xsl:when test="matches(normalize-space(.),'^[a-z]{3}$')">
                    <!-- skip the 3 letter codes -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                </xsl:otherwise>
            </xsl:choose>
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
                    <xsl:when test="contains(normalize-space(.), 'Penelope Johnson Allen Brainerd Mission Correspondence and Photographs')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Penelope Johnson Allen Brainerd Mission correspondence and photographs digital collection features orignal correspondence and receipts created by the United States Department of War, Indian Agent Return J. Meigs, and Brainerd Mission superintendents and founders Gideon Blackburn, Cyrus Kingsbury, and Ard Hoyt. The collection also includes photographs of portraits of the Brainerd missionaries, Daughters of the American Revolution dedication events at Brainerd Mission Cemetery, and copies of etchings of Brainerd Mission.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll7</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                   <xsl:when test="contains(normalize-space(.), 'R. M. Bigelow Civil War Nursing Correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The R. M. Bigelow Civil War nursing correspondence digital collection includes four letters written by R. M. Bigelow, providing documentation about the roles of women during the Civil War. The letters are dated from 1862 to 1866.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll18</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Black United Front Newsletters')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Black United Front newsletters digital collection documents the Black Power movement in Chattanooga, Tennessee  from 1969 to 1971. The newsletters include powerful language and imagery that preserves African American voices of the early Post-Civil Rights era. Created by Ralph Moore, a native Chattanoogan and member of Black Knights, Inc., the newsletters are a product of Moore's vision and his collaboration with other local activists, many of who had been involved in the Student Nonviolent Coordinating Committee (SNCC).</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll20</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Cavalier Corporation Histories and Balance Sheets')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Cavalier Corporation histories and balance sheets digital collection features corporate histories and balance sheets that document the company's production of soda machines, coolers, and picnic chests for Coca-Cola.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll16</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Chattanooga Postcards and Viewbooks')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Chattanooga postcards and viewbooks digital collection features souvenir postcards and books dating back to the early 20th century. The collection depicts points of interest in and around Chattanooga, Tennessee including Lookout Mountain, Chickamauga, and downtown.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll12</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Chattanooga Women's Oral Histories')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Chattanooga women's oral histories digital collection features interviews with women in and around Chattanooga, Tennessee. Interivewees were asked questions such as "What are some of your early memories of Chattanooga?" and "What do you preceive to tbe the core elements of a successful city?" The interviews celebrate the accomplishments and experiences of women business leaders, advocates, educators, social activists, and community builders across generation, socioeconomic, and cultural backgrounds.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll21</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'George Connor Speeches')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The George Connor speeches digital collection includes manuscripts and drafts of speeches delivered by the University of Tennessee at Chattanooga Guerry Professor of English. Connor dedicated his life to education, and in 1985, his colleagues, former students, and friends endowed the George C. Connor Professorship in American literature in honor of Connor’s 26 years of service to the university.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll13</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'George Ayers Cress Artist Studio Photographs')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The George Ayers Cress artist studio photographs digital collection includes photographs taken by Cress while visiting the homes and studios of artists, including Henry Moore, John Piper, and William Scott. George Ayers Cress was a prolific painter who joined the faculty of the University of Chattanooga in 1951. Cress taught at the university of 56 years, serving as the chair of the Department of Art. Cress was also a Alexander and Charlotte Patten Guerry Professor, a distinction awarded to outstanding professors.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll10</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Concha Espina Spanish Literature Correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Concha Espina Spanish literature correspondence digital collection features letters written by the Spanish novellist to Terrell Tatum, a professor of Spanish at the University of Chattanooga from 1924 to 1967. The letters range in date from 1931 to 1955 and cover a variety of topics, including Espina's most famous work, La Niña de Luzmela.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll11</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Ralph W. Hood and W. Paul Williamson Holiness Churches of Appalachia')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Ralph W. Hood and W. Paul Williamson holiness churches of Appalachia recordings and interviews digital collection features a small sample of more than 400 hours of church services and interviews documenting contemporary serpent handlers of Southern Appalachia. Ranging from 1975 to 2004, this collection focuses on the major Pentecostal congregations that practice speaking in tongues, imbibing poisons, and serpent handling in the southeastern United States.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll2</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Krystal Gazer Newsletters')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Krystal Gazer newsletters digital collection is a corporate newsletter that documents the storied history of Krystal restaurants in Chattanooga, the state of Tennessee, and the South. The newsletters provide valuable insight into the restaurant's work culture and business practices as well as its impact on the community.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll14</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Cyrus Griffin Martin World War I Diaries and Military Records')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Cyrus Griffin Martin World War I diares and correspondence digital collection contains Martin's correspondence, military records, financial records, and notepads created during his service as a Second Lieutenant in the American Expeditionary Forces during World War I. The contents of the collection date from 1917 to 1919.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll14</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Emma Bell Miles Southern Appalachia Art and Correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Emma Bell Miles southern Appalachia art and correspondence digital collection contains correspondence among members and friends of writer and artist Emma Bell Miles’ family of origin illustrating the personal roots of themes Emma lived out and developed in her work. The heart of the collection is a series of letters written during 1901-1903 concerning Emma’s troubled relationship with her parents, her life as a young woman, and her life as an emerging artist and naturalist; as well as the death of her mother, Emma’s marriage to Frank Miles soon thereafter, and disposition of Bell family property in Walden Ridge, Tennessee. The collection also features numerous examples of Emma's art, including watercolors, oil paintings, and sketches.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll6</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Leroy M. Sullivan World War II Diaries and Correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Leroy M. Sullivan World War II diaries and correspondence digital collection features three diaries and sixteen letters authored by Leroy M. Sullivan, a Flight Lieutenant in the Royal Canadian Air Force, during World War II from 1940 to 1943, when Sullivan was killed in action. The diaries document Lieutenant Sullivan's participation in campaigns in England, South Africa, Sudan, and Egypt, and the letters to Sullivan's friend, Grady Long, detail daily life in the military, especially the ways in which he and his fellow soldiers spent their time between operations.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll5</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'University of Tennessee at Chattanooga Course Catalogs')">
                            <relatedItem type='host' displayLabel='Project'>
                                <titleInfo>
                                    <title><xsl:value-of select="normalize-space(.)"/></title>
                                </titleInfo>
                                <abstract>The University of Tennessee at Chattanooga Course Catalogs digital collection features volumes of bulletins ranging from 1891 to 1959. The course catalogs provide a glimpse into the history of higher education at the university, documenting course offerings, tuition and fees, administrators and faculty, academic calendars, and degree offerings.</abstract>
                                <location>
                                    <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll15</url>
                                </location>
                            </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'University of Tennessee at Chattanooga Echo Student Newspaper')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The University of Tennessee at Chattanooga Echo student newspapers digital collection features the issues of newspapers produced by university students from 1888 to 2011. The University Lookout, a precursor to the University Echo, is part literary magazine and part student newspaper and it is also included in this digital collection.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll9</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'University of Tennessee at Chattanooga Moccasin Yearbooks')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The University of Tennessee at Chattanooga Moccasin yearbooks digital collection features all 63 volumes of the the Moccasin ranging from 1911 to 1991. Published by students enrolled at the University of Chattanooga (1907-1969) and the University of Tennessee at Chattanooga (1969-present), the Moccasin documents athletics, social functions, and the physical plant, including sections dedicated to student organizations, administrators, and academic departments.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll3</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'University of Tennessee at Chattanooga President and Chancellor Portraits')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The University of Tennessee at Chattanooga president and chancellor portraits digital collection features oil paintings of 12 of the 17 presidents and chancellors of the university, including it's predecessor institutions Chattanooga University, Grant University, and University of Chattanooga. University leaders not represented in this collection include Fred W. Hinson, Alexander Guerry, Archie Palmer, E. Grady Bogue, and current chancellor Steven R. Angle.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll17</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Lula Ulrica Whitaker Southern Agrarian Writers Correspondence')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Lula Ulrica Whitaker Southern Agrarian writers correspondence digital collection contains correspondence from nine of the authors known as the Twelve Southerners. The correspondence, written in 1934, describes each author's understanding of the Southern Agrarian movement.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll4</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'John T. Wilder Civil War Correspondence and Papers')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The John T. Wilder Civil War correspondence and papers digital collection contains correspondence and military records regarding Brigadier General Wilder's service in the Union Army during the American Civil War from 1861-1865 as well as personal correspondence and papers dating from 1865 to 1937.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll1</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                    <xsl:when test="contains(normalize-space(.), 'Raymond B. Witt Chattanooga Public Schools Desegregation Records')">
                        <relatedItem type='host' displayLabel='Project'>
                            <titleInfo>
                                <title><xsl:value-of select="normalize-space(.)"/></title>
                            </titleInfo>
                            <abstract>The Raymond B. Witt Chattanooga public schools desegregation records digital collection documents Chattanooga's response to the United States Supreme Court decision in Brown v. Board of Education of Topeka that ruled segregation in public schools unconstitutional in 1955. As chair and member of the Chattanooga Board of Education and as the chief attorney for the defendant in the 1960 case, Mapp v. Board of Education of Chattanooga, in which the NAACP supported the case of James Jonathan Mapp to force public school integration in Chattanooga, Raymond B. Witt amassed legal documents, correspondence, meeting minutes, and other records created by the Board of Education, the United States District Court, and many citizens of Chattanooga.</abstract>
                            <location>
                                <url>http://cdm16877.contentdm.oclc.org/cdm/landingpage/collection/p16877coll8</url>
                            </location>
                        </relatedItem>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="rightsRepair">
        <xsl:for-each select="dc:rights">
            <xsl:choose>
                <xsl:when test="matches(normalize-space(.),'^[a-z]{3}$')">
                    <!-- skip the 3 letter codes -->
                </xsl:when>
                <xsl:when test="not(matches(normalize-space(.),'^[a-z]{3}$')) and normalize-space(.) != ''">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <accessCondition>Under copyright.</accessCondition>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="dc:subject">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:call-template name="LCSHtopic">
                <xsl:with-param name="term"><xsl:value-of select="replace(., ' -- ', '--')"/></xsl:with-param>
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

    <xsl:template match="dc:type">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:call-template name="AATgenre">
                <xsl:with-param name="term"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
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
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
