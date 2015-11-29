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
                <recordContentSource>University of Tennessee, Chattanooga. Library</recordContentSource>
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
                    <xsl:when test="contains(normalize-space(.), 'Raymond B. Witt Chattanooga Public Schools Desegregation records') or contains(normalize-space(.), 'Raymond B. Witt legal documents, records, and correspondence')">
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
