<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0" xmlns="http://www.loc.gov/mods/v3">

    <xsl:template match="dc:coverage" mode="dltn">
        <xsl:variable name="coveragevalue" select="normalize-space(.)"/>
        <xsl:for-each select="tokenize($coveragevalue,';')">
            <xsl:if test="normalize-space(.)!=''">
                <xsl:choose>
                    <!-- check to see if there are any numbers in this coverage value -->
                    <xsl:when test='matches(.,"\d+")'>
                        <xsl:choose>
                            <!-- coordinates? -->
                            <xsl:when test='matches(.,"\d+\.\d+")'>
                                <subject>
                                    <cartographic>
                                        <coordinates>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </coordinates>
                                    </cartographic>
                                </subject>
                            </xsl:when>
                            <!-- temporal? -->
                            <xsl:otherwise>
                                <subject>
                                    <temporal>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </temporal>
                                </subject>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- geo data as text? --> 
                    <xsl:otherwise>
                        <subject>
                            <geographic>
                                <xsl:value-of select="normalize-space(.)"/>
                            </geographic>
                        </subject>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>  
        
    <xsl:template match="dc:date" mode="dltn">
        <xsl:call-template name="date-to-mods">
            <xsl:with-param name="dateval">
                <xsl:value-of select="normalize-space(.)"/>                    
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
        
    <xsl:template name="date-to-mods">
        <xsl:param name="dateval"/>
        <xsl:variable name="date_list" select="tokenize($dateval, ';')"/>
        <xsl:variable name="list_length" select="count($date_list)"/>
        <xsl:choose>
            <xsl:when test="$list_length > 1">
                <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" keyDate="yes" point="start">
                    <xsl:call-template name="datequal">
                        <xsl:with-param name="dateval" select="$date_list[1]"/>
                    </xsl:call-template>
                    <xsl:call-template name="clean-date">
                        <xsl:with-param name="dateval">
                            <xsl:value-of select="normalize-space($date_list[1])"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </dateCreated>
                
                <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" point="end">
                    <xsl:call-template name="datequal">
                        <xsl:with-param name="dateval" select="normalize-space($date_list[$list_length])"/>
                    </xsl:call-template>
                    <xsl:call-template name="clean-date">
                        <xsl:with-param name="dateval">
                            <xsl:value-of select="normalize-space($date_list[$list_length])"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </dateCreated>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="date_parts" select="tokenize($dateval, '-')"/>
                <xsl:variable name="parts_length" select="count($date_parts)"/>
                <xsl:choose>
                    <xsl:when test="$parts_length = 3">
                        <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" keyDate="yes">
                            <xsl:call-template name="datequal">
                                <xsl:with-param name="dateval" select="normalize-space(.)"/>
                            </xsl:call-template>
                            <xsl:call-template name="clean-date">
                                <xsl:with-param name="dateval">
                                    <xsl:value-of select="."/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </dateCreated>                                              
                    </xsl:when>
                    <xsl:when test="$parts_length = 2">
                        <xsl:choose>
                            <xsl:when test="string-length($date_parts[2]) >= 4">
                                <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" keyDate="yes" point="start">
                                    <xsl:call-template name="datequal">
                                        <xsl:with-param name="dateval" select="normalize-space($date_parts[1])"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="clean-date">
                                        <xsl:with-param name="dateval">
                                            <xsl:value-of select="normalize-space($date_parts[1])"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </dateCreated>
                                <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" point="end">
                                    <xsl:call-template name="datequal">
                                        <xsl:with-param name="dateval" select="normalize-space($date_parts[2])"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="clean-date">
                                        <xsl:with-param name="dateval">
                                            <xsl:value-of select="normalize-space($date_parts[2])"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </dateCreated>
                            </xsl:when>
                            <xsl:otherwise>
                                <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" keyDate="yes">
                                    <xsl:call-template name="datequal">
                                        <xsl:with-param name="dateval" select="normalize-space($date_parts[1])"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="clean-date">
                                        <xsl:with-param name="dateval">
                                            <xsl:value-of select="normalize-space($date_parts[1])"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </dateCreated>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="normalize-space(.)!='9999'">
                            <dateCreated xsl:exclude-result-prefixes="xsi oai_dc dc" keyDate="yes">
                                <xsl:call-template name="datequal">
                                    <xsl:with-param name="dateval" select="normalize-space(.)"/>
                                </xsl:call-template>
                                <xsl:call-template name="clean-date">
                                    <xsl:with-param name="dateval">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </dateCreated>   
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- determine qualifier attribute for date element. -->
    <xsl:template name="datequal">
        <xsl:param name="dateval"/>
        <xsl:choose>
            <xsl:when test="starts-with(lower-case($dateval), 'c')">
                <xsl:attribute name="qualifier" exclude-result-prefixes="#all">approximate</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains($dateval, '?')">
                <xsl:attribute name="qualifier" exclude-result-prefixes="#all">questionable</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains($dateval, '[')">
                <xsl:attribute name="qualifier" exclude-result-prefixes="#all">inferred</xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>        
    </xsl:template>
    
    <!-- strip superfluous characters from date once it's been qualified -->
    <xsl:template name="clean-date">
        <xsl:param name="dateval"/>
        <xsl:value-of select="replace($dateval, '[^0-9\-/]', '')"/>
    </xsl:template>
    
    <xsl:template match="dc:type" mode="dltn">
        <!-- we override this template to provide a more complete typeOfResource element
      more closely conforming to the standard -->
        <!-- always tokenize, since we sometimes get single values with a delimiter -->
        <xsl:for-each select="tokenize(., ';')">
            <!-- check for empty element -->
            <xsl:if test="normalize-space(.) != ''">
                <xsl:variable name="dc-type" select="lower-case(normalize-space(.))" />
                    <xsl:choose>
                        <xsl:when test="$dc-type = lower-case('Collection')">
                            <xsl:element name="typeOfResource">
                                <xsl:attribute name="collection">yes</xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('Dataset')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>software, multimedia</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="starts-with($dc-type, lower-case('Image'))">
                            <xsl:element name="typeOfResource">
                                <xsl:text>still image</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('Moving Image')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>moving image</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('Still Image')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>still image</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('InteractiveResource')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>software, multimedia</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('PhysicalObject')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>three-dimensional object</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('Service')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>software, multimedia</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('Sound')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>sound recording</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$dc-type = lower-case('Text') or $dc-type = lower-case('DOCUMENT')">
                            <xsl:element name="typeOfResource">
                                <xsl:text>text</xsl:text>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
<!--                <xsl:call-template name="mods-genre" >
                    <xsl:with-param name="dc_type" select="$dc-type" />
                </xsl:call-template>
-->            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="mods-type">
        <xsl:param name="dc_type"/>
        <xsl:choose>
            <xsl:when test="$dc_type = lower-case('Dataset')">
                <typeOfResource type="dct">dataset</typeOfResource>
            </xsl:when>
            <xsl:when test="starts-with($dc_type, lower-case('Image'))">
                <typeOfResource type="dct">image</typeOfResource>
            </xsl:when>
            <xsl:when test="$dc_type = lower-case('InteractiveResource')">
                <typeOfResource type="dct">interactive resource</typeOfResource>
            </xsl:when>
            <xsl:when test="$dc_type = lower-case('Service')">
                <typeOfResource type="dct">service</typeOfResource>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="dltn">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'http')">
            <!-- CONTENTdm puts the URI in an <identifier> field in the OAI record -->
            <location>
                <url usage="primary display" access="object in context">
                    <xsl:value-of select="$idvalue"/>
                </url>
            </location>         
            <!-- process identifier into CONTENTdm 6.5 thumbnail urls --> 
            <xsl:variable name="contentdmroot" select="substring-before($idvalue,'/cdm/ref/')"/>
            <xsl:variable name="recordinfo" select="substring-after($idvalue,'/cdm/ref/collection/')"/>
            <xsl:variable name="alias" select="substring-before($recordinfo,'/id/')"/>
            <xsl:variable name="pointer" select="substring-after($recordinfo,'/id/')"/>
            <location><url access="preview"><xsl:value-of select="concat($contentdmroot,'/utils/getthumbnail/collection/',$alias,'/id/',$pointer)"/></url></location> <!--CONTENTdm thumbnail url-->
            <!-- end CONTENTdm thumbnail url processing -->           
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:language" mode="dltn">
        <xsl:variable name="languagevalue" select="normalize-space(.)"/>
        <xsl:element name="language">
            <xsl:for-each select="tokenize($languagevalue,';')">
                <xsl:if test="normalize-space(.)!=''">
                    <languageTerm>
                        <xsl:value-of select="normalize-space(.)"/>
                    </languageTerm>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="repository">
        <xsl:param name="repository"/>
        <xsl:element name="physicalLocation">
            <xsl:value-of select="$repository"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
