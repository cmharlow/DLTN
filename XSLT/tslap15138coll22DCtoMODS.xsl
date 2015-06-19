<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:include href="tsladctomods.xsl"/>
        
    <xsl:template match="text()|@*"/>    
    <xsl:template match="//oai_dc:dc">
        <mods xmlns:xlink="http://www.w3.org/1999/xlink" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="dc:title" mode="SSN"/> <!-- titleInfo/title and part/detail|date parsed out -->
            <xsl:apply-templates select="dc:identifier"/> <!-- identifier -->
            
            <xsl:if test="dc:date|dc:publisher">
                <originInfo> 
                    <xsl:apply-templates select="dc:date"/> <!-- date (text + key) -->
                    <xsl:apply-templates select="dc:publisher" /> <!-- publisher -->
                </originInfo>
            </xsl:if>
            
            <xsl:if test="dc:format|dc:type">
                <physicalDescription>
                    <xsl:apply-templates select="dc:format"/> <!-- extent, internetMediaTypes -->
                    <xsl:apply-templates select="dc:type" mode="form"/> <!-- form -->
                </physicalDescription>
            </xsl:if>
            
            <xsl:if test="dc:identifier|dc:source">
                <location>
                    <xsl:apply-templates select="dc:identifier" mode="URL"/> <!-- object in context URL -->
                    <xsl:apply-templates select="dc:identifier" mode="locationurl"/> <!-- thumbnail url -->
                    <xsl:apply-templates select="dc:source" mode="repository"/> <!-- repository -->
                </location>
            </xsl:if>
            
            <xsl:apply-templates select="dc:format" mode="itemType"/> <!-- Item Type -->
            <xsl:apply-templates select="dc:format" mode="genre"/> <!-- Genre -->
            <xsl:apply-templates select="dc:rights"/> <!-- accessCondition -->
            <xsl:apply-templates select="dc:subject"/> <!-- subject - parsed -->
            <xsl:apply-templates select="dc:coverage"/> <!-- subject info -->
            <xsl:apply-templates select="dc:source"/> <!-- series title -->
            <xsl:apply-templates select="dc:type"/> <!-- genre -->
            <xsl:apply-templates select="dc:type" mode="type"/> <!-- item types -->
            <relatedItem type='host' displayLabel="Project">
                <titleInfo>
                    <title>Southern School News Collection</title>
                </titleInfo>
                <abstract>Southern School News was published by the Southern Education Reporting Service (SERS) a fact-finding agency established by southern newspaper editors and educators with the aim of providing unbiased information to school administrators, public officials and interested lay citizens on developments in education arising from the U.S. Supreme Court opinion of May 17, 1954, Brown v. Board of Education of Topeka Kansas. This full text searchable digital collection is comprised of 11 volumes with 12 Issues containing twelve to twenty-four pages each which were published from September 1954 through June 1965 in Nashville, Tennessee. Beginning with the publication of the first issue, September 3, 1954, each journal impartially reported desegregation of U.S. public schools state by state through primary documentation and statistical evidence. Changes in public school education in 17 United States southern and border states as well as the District of Columbia was communicated to benefit educational administrators and officials. The goal of the publication was to provide "a reliable, central source of information on developments in education arising from the United States Supreme Court decision declaring compulsory racial segregation in the public schools to be unconstitutional." (Southern School News, Volume 11 Issue 12, p. 1). The Board of Directors for the publication was drawn from a wide divergence of both political and educational backgrounds to include both segregation and desegregation interpretations of the Supreme Court ruling. Members of the Board included such distinguished Tennessee leaders as presidents and chancellors of Fisk and Vanderbilt Universities as well as George Peabody College. Also included were the editors of both The Nashville Banner and The Nashville Tennessean.</abstract>
                <location>
                    <url>http://tn.gov/tsla/TeVAsites/SouthernSchoolNews/index.htm</url>
                </location>
            </relatedItem>
            <xsl:call-template name="recordSource"/>
        </mods>
    </xsl:template>
    
    <xsl:template match="dc:title" mode="SSN">
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
                <xsl:otherwise>
                    <titleInfo>
                        <title>Southern School News</title>
                    </titleInfo>
                    <part>
                        <detail>
                            <number><xsl:value-of select="replace(normalize-space(.), 'SSN ', '')"/></number>
                        </detail>
                    </part>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:coverage">
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!='' and normalize-space(lower-case(.))!='unknown'">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(.), 'Southern Education Reporting Service')">
                        <subject>
                            <name authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n82047462">Southern Education Reporting Service</name>
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
    
    <xsl:template match="dc:format"> <!-- should go into PhysicalDescription wrapper -->
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'application/pdf')">
                        <internetMediaType>application/pdf</internetMediaType>
                    </xsl:when>
                    <xsl:otherwise>
                        <note><xsl:value-of select="normalize-space(.)"/></note>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="itemType"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'journals')">
                        <typeOfResource>text</typeOfResource>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="form"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'journals')">
                        <form><xsl:value-of select="normalize-space(.)"/></form>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="dc:format" mode="genre"> 
        <xsl:for-each select="tokenize(normalize-space(.), ';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <xsl:when test="matches(normalize-space(lower-case(.)), 'journals')">
                        <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300215390">journals (periodicals)</genre>
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
        <xsl:if test="normalize-space(.)!='' and starts-with(normalize-space(.), 'Southern')">
            <relatedItem type="series">
                <titleInfo>
                    <title><xsl:value-of select="normalize-space(.)"/></title>
                </titleInfo>
            </relatedItem>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:source" mode="repository">
        <xsl:if test="normalize-space(.)!='' and starts-with(normalize-space(.), 'Tennessee State Library')">
            <physicalLocation><xsl:value-of select="normalize-space(.)"/></physicalLocation>
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
                <xsl:when test="contains(normalize-space(lower-case(.)), 'text')">
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
                </xsl:when>
                <xsl:otherwise>
                    <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
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
                <xsl:when test="contains(normalize-space(lower-case(.)), 'image') or contains(normalize-space(lower-case(.)), 'photographed')">
                    <typeOfResource>still image</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'object')">
                    <typeOfResource>three dimensional object</typeOfResource>
                </xsl:when>
                <xsl:when test="contains(normalize-space(lower-case(.)), 'scanned') or contains(normalize-space(lower-case(.)), 'text')">
                    <typeOfResource>text</typeOfResource>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
