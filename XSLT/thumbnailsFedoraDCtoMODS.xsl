<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:oai_dc='http://www.openarchives.org/OAI/2.0/oai_dc/' xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    version="2.0" xmlns="http://www.loc.gov/mods/v3">
    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8" indent="yes"/>
    <!-- OAI-DC to MODS Fedora Transformations for Thumbnail URL additions. -->
    
    <xsl:template match="dc:identifier" mode="locationurl">
        <xsl:variable name="idvalue" select="normalize-space(.)"/>
        <xsl:if test="starts-with($idvalue,'rds:')"> 
            <!-- Crossroads Fedora puts the PID in an <identifier> field in the OAI record --><!-- process Fedora thumbnail urls -->           
            <xsl:variable name="PID" select="substring-after($idvalue,'rds:')"/>
            <url access="preview"><xsl:value-of select="concat('http://crossroads.rhodes.edu:9090/fedora/get/rds:',$PID,'/thumbnail_100x75.jpg')"/></url> <!--CONTENTdm thumbnail url-->
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="dc:identifier" mode="crossroadsURL">
        <xsl:if test="starts-with(normalize-space(.),'rds:')"> 
            <!-- Crossroads Fedora puts the PID in an <identifier> field in the OAI record --><!-- process Fedora object in context urls -->           
            <xsl:variable name="PID" select="substring-after(normalize-space(.),'rds:')"/>
            <url access="object in context" usage="primary"><xsl:value-of select="concat('http://www.crossroadstofreedom.org/view.player?pid=rds:',$PID)"/></url> <!--CONTENTdm thumbnail url-->
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>