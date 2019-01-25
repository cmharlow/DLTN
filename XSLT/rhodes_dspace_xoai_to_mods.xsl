<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lyncode="http://www.lyncode.com/xoai"
    xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.lyncode.com/xoai" version="2.0">

    <!-- output settings -->
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- includes and imports -->

    <!--
    Collection/Set = Crossroads Friends and Family
  -->

    <!-- identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- normalize all the text! -->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!-- match metadata -->
    <xsl:template match="lyncode:metadata">
        <!-- match the document root and return a MODS record -->
        <mods xmlns="http://www.loc.gov/mods/v3" version="3.5"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            
            <!-- title-->
            <xsl:apply-templates select="element[@name = 'dc']/element[@name = 'title']/element/field"/>
            
            <!-- rights-->
            <accessCondition type="local rights statement">All rights reserved. The accompanying
                digital object and its associated documentation are provided for online research and
                access purposes. Permission to use, copy, modify, distribute and present this
                digital object and the accompanying documentation, without fee, and without written
                agreement, is hereby granted for educational, non-commercial purposes only. The
                Rhodes College Archives reserves the right to decide what constitutes educational
                and commercial use; commercial users may be charged a nominal fee to be determined
                by current, commercial rates for use of special materials. In all instances of use,
                acknowledgement must begiven to Rhodes College Archives and Special Collection,
                Memphis, TN. For information regarding permission to use this image, please email
                the Archives at archives@rhodes.edu or call 901-843-3334.</accessCondition>
            
            <!-- urls -->
            <location>
                <xsl:apply-templates select='element[@name = "dc"]/element[@name = "identifier"]/element[@name = "uri"]/element[@name = "none"]/field[@name = "value"]'/>
                <xsl:apply-templates select='element[@name="bundles"]/element[@name="bundle"][field[@name="name"][text()="THUMBNAIL"]]/element[@name="bitstreams"]/element[@name="bitstream"]/field[@name="url"]'/>
            </location>
            
            <!-- Contributors -->
            <xsl:apply-templates select='element[@name = "dc"]/element[@name="contributor"]/element[@name = "none"]/field[@name = "value"]'/>
 
            <!-- Creators -->
            <xsl:apply-templates
                select='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "editor"]/element[@name = "none"]/field[@name = "value"]'/>

            <!-- OriginInfo -->
            <originInfo>
                <xsl:apply-templates
                    select='element[@name = "dc"]/element[@name = "date"]/element[@name = "issued"]/element[@name = "none"]/field[@name = "value"]'
                />
                <xsl:apply-templates select='element[@name = "dc"]/element[@name = "publisher"]/element[@name = "en_US"]/field[@name = "value"]'/>
            </originInfo>
            
            <!-- recordInfo -->
            <recordInfo>
                <recordContentSource>Rhodes College. Crossroads to Freedom</recordContentSource>
                <recordChangeDate><xsl:value-of select="current-date()"/></recordChangeDate>
                <languageOfCataloging>
                    <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
                </languageOfCataloging>
                <recordOrigin>Record has been transformed into MODS 3.5 from a Qualified Dublin Core record by the Digital Library of Tennessee, a service hub of the Digital Public Library of America, using a stylesheet available at https://github.com/digitallibraryoftennessee/DLTN_XSLT. Metadata originally created in a locally modified version of Qualified Dublin Core using ContentDM (data dictionary available: https://wiki.lib.utk.edu/display/DPLA).</recordOrigin>
            </recordInfo>
            
            <!-- typeOfResource -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="type"]/element[@name="en_US"]/field[@name="value"]'/>
            
            <!-- identifiers -->
            <xsl:apply-templates select='element[@name="dc"]/element[@name="identifier"]/element[@name="rhodes"]/element[@name="none"]/field[@name="value"]'/>
            
            <!-- Subjects -->
            <xsl:apply-templates select='element[@name = "dc"]/element[@name = "subject"]/element[@name = "none"]/field[@name = "value"]'/>
            <xsl:apply-templates select='element[@name = "dc"]/element[@name = "subject"]/element[@name = "en_US"]/field[@name = "value"]'/>
        </mods>
    </xsl:template>

    <!-- title -->
    <xsl:template match="element[@name = 'dc']/element[@name = 'title']/element/field">
        <titleInfo>
            <title>
                <xsl:apply-templates/>
            </title>
        </titleInfo>
    </xsl:template>

    <!-- Thumbnail -->
        <xsl:template match='element[@name="bundles"]/element[@name="bundle"][field[@name="name"][text()="THUMBNAIL"]]/element[@name="bitstreams"]/element[@name="bitstream"]/field[@name="url"]'>
            <url type="preview"><xsl:apply-templates/></url>
    </xsl:template>

    <!-- Handle -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "identifier"]/element[@name = "uri"]/element[@name = "none"]/field[@name = "value"]'>
        <url type="object in context">
            <xsl:apply-templates/>
        </url>
    </xsl:template>

    <!-- Contributors -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "none"]/field[@name = "value"]'>
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm>Contributor</roleTerm>
            </role>
        </name>
    </xsl:template>

    <!-- Creators -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "contributor"]/element[@name = "editor"]/element[@name = "none"]/field[@name = "value"]'>
        <name>
            <namePart>
                <xsl:apply-templates/>
            </namePart>
            <role>
                <roleTerm>Creator</roleTerm>
            </role>
        </name>
    </xsl:template>

    <!-- Date Created -->
    <xsl:template
        match='element[@name = "dc"]/element[@name = "date"]/element[@name = "issued"]/element[@name = "none"]/field[@name = "value"]'>
        <dateCreated>
            <xsl:apply-templates/>
        </dateCreated>
    </xsl:template>
    
    <!-- typeOfResource -->
    <xsl:template match='element[@name="dc"]/element[@name="type"]/element[@name="en_US"]/field[@name="value"]'>
        <typeOfResource><xsl:apply-templates/></typeOfResource>
    </xsl:template>
    
    <!-- identifiers -->
    <xsl:template match='element[@name="dc"]/element[@name="identifier"]/element[@name="rhodes"]/element[@name="none"]/field[@name="value"]'>
        <identifier type="local"><xsl:apply-templates/></identifier>
    </xsl:template>
    
    <!-- Subjects -->
    <xsl:template match='element[@name = "dc"]/element[@name = "subject"]/element[@name = "none"]/field[@name = "value"]'>
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
    </xsl:template>
    
    <!-- Subjects -->
    <xsl:template match='element[@name = "dc"]/element[@name = "subject"]/element[@name = "en_US"]/field[@name = "value"]'>
        <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
        </subject>
    </xsl:template>
    
    <!-- Publisher -->
    <xsl:template match='element[@name = "dc"]/element[@name = "publisher"]/element[@name = "en_US"]/field[@name = "value"]'>
        <publisher><xsl:apply-templates/></publisher>
    </xsl:template>
    
</xsl:stylesheet>
