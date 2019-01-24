<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs"
    xmlns="http://www.lyncode.com/xoai"
    xpath-default-namespace="http://www.lyncode.com/xoai"
    version="2.0">
    
    <!-- output settings -->
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- includes and imports -->
    
    <!--
    Collection/Set = Crossroads Friends and Family
  -->
    
    <!-- identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- normalize all the text! -->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <!-- match metadata -->
    <xsl:template match="metadata">
        <!-- match the document root and return a MODS record -->
        <mods xmlns="http://www.loc.gov/mods/v3" version="3.5" 
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <!-- delete-->
            <xsl:apply-templates select='element[@name="repository"]/field[@name="name"]'/>
            <!-- title-->
            <xsl:apply-templates select="element[@name='dc']/element[@name='title']/element/field"/>
            <accessCondition type="local rights statement">All rights reserved. The accompanying digital object and its associated documentation are provided for online research and access purposes. Permission to use, copy, modify, distribute and present this digital object and the accompanying documentation, without fee, and without written agreement, is hereby granted for educational, non-commercial purposes only. The Rhodes College Archives reserves the right to decide what constitutes educational and commercial use; commercial users may be charged a nominal fee to be determined by current, commercial rates for use of special materials. In all instances of use, acknowledgement must begiven to Rhodes College Archives and Special Collection, Memphis, TN. For information regarding permission to use this image, please email the Archives at archives@rhodes.edu or call 901-843-3334.</accessCondition>
            <location>
                <xsl:apply-templates select='element[@name="dc"]/element[@name="identifier"]/element[@name="uri"]/element[@name="none"]/field[@name="value"]'></xsl:apply-templates>
            </location>
        </mods>
    </xsl:template>
    
    <!-- test delete -->
    <xsl:template match='element[@name="repository"]/field[@name="name"]'>
        <recordInfo>
            <recordContentSource><xsl:apply-templates/></recordContentSource>
        </recordInfo>
    </xsl:template>
    
    <!-- title -->
    <xsl:template match="element[@name='dc']/element[@name='title']/element/field">
        <titleInfo>
            <title>
                <xsl:apply-templates/>
            </title>
        </titleInfo>
    </xsl:template>
    
    <!-- Thumbnail -->
<!--    <xsl:template match='element[@name="bundles"]/element[@name="bundle"][field[@name="name"]]//descendant::field[@name="URL"]'>
            <url><xsl:apply-templates/></url>
    </xsl:template>-->
    
    <!-- Handle -->
    <xsl:template match='element[@name="dc"]/element[@name="identifier"]/element[@name="uri"]/element[@name="none"]/field[@name="value"]'>
        <url type="object in context">
            <xsl:apply-templates/>
        </url>
    </xsl:template>
    
</xsl:stylesheet>