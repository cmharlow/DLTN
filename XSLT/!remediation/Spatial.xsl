<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs"
    version="2.0">    
    
    <!-- lookup tables for most common Spatial terms/URIs -->
    <xsl:template name="SpatialTopic">
        <xsl:param name="term"/>
        <xsl:variable name="topic" select="normalize-space(lower-case($term))"/>
        <xsl:choose>
            <xsl:when test="matches($topic, '^\d{4}s$')">
                <subject>
                    <temporal encoding="edtf"><xsl:value-of select="concat(concat(replace(normalize-space($topic), 's', ''), '/'), replace(normalize-space(.), '0s', '9'))"/></temporal>
                </subject>
            </xsl:when>
            
            <!-- City Districts/Neighborhoods that need to go before the Cities for matching purposes -->
            <xsl:when test="matches($topic, 'beale street')">
                <subject>
                    <geographic authority="lcsh" valueURI="http://id.loc.gov/authorities/names/sh85012635">Beale Street (Memphis, Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.13898, -90.0487</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="contains($topic,'evergreen') and contains($topic,'memphis') and contains($topic,'tennessee')">
                <subject>
                    <geographic>Evergreen Historic District (Memphis, Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.1479, -90.0072</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            
            <!-- Cities, States, Countries, etc. -->
            <xsl:when test="(contains($topic,'albany') and contains($topic,'georgia')) or matches($topic, 'albany (ga.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n81107844">Albany (Ga.)</geographic>
                    <cartographics>
                        <coordinates>31.57851, -84.15574</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'alcoa') and contains($topic,'tennessee')) or matches($topic, 'alcoa (tenn.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n80022862">Alcoa (Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.78953, -83.97379</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'alexandria') and contains($topic,'virginia')) or matches($topic, 'alexandria (va.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79099306">Alexandria (Va.)</geographic>
                    <cartographics>
                        <coordinates>38.80484, -77.04692</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'anderson') and contains($topic,'indiana')) or matches($topic, 'anderson (ind.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n50074868">Anderson (Ind.)</geographic>
                    <cartographics>
                        <coordinates>40.10532, -85.68025</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'atlanta') and contains($topic,'georgia')) or matches($topic, 'atlanta (ga.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79023214">Atlanta (Ga.)</geographic>
                    <cartographics>
                        <coordinates>33.749, -84.38798</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'attala') and contains($topic,'mississippi')) or matches($topic, 'attala county (miss.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n82101331">Attala County (Miss.)</geographic>
                    <cartographics>
                        <coordinates>33.08629, -89.58155</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'brownsville') and contains($topic,'tennessee')) or matches($topic, 'brownsville (tenn.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n84008639">Brownsville (Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.59397, -89.26229</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'birmingham') and contains($topic,'alabama')) or matches($topic, 'birmingham (ala.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79042167">Birmingham (Ala.)</geographic>
                    <cartographics>
                        <coordinates>33.52066, -86.80249</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'boston') and contains($topic,'massachusetts')) or matches($topic, 'boston (mass.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79045553">Boston (Mass.)</geographic>
                    <cartographics>
                        <coordinates>42.35843, -71.05977</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'chicago') and contains($topic,'illinois')) or matches($topic, 'chicago (ill.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78086438">Chicago (Ill.)</geographic>
                    <cartographics>
                        <coordinates>41.85003, -87.65005</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'great smoky mountains')">
                <subject authority="lcsh" valueURI="http://id.loc.gov/authorities/subjects/sh85057008">
                    <geographic>Great Smoky Mountains (N.C. and Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.58343, -83.50822</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'hoxie') and contains($topic,'arkansas')) or matches($topic, 'hoxie (ark.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n83030241">Hoxie (Ark.)</geographic>
                    <cartographics>
                        <coordinates>36.05035, -90.97512</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains($topic,'macon') and contains($topic,'georgia')) or matches($topic, 'macon (ga.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79133192">Macon (Ga.)</geographic>
                    <cartographics>
                        <coordinates>32.84069, -83.6324</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'memphis') or matches($topic, 'memphis, tenn.') or matches($topic, 'memphis (tenn.)') or (contains($topic,'memphis') and contains($topic,'tennessee'))">
                <subject>
                    <geographic authority="naf" valueURI="http://id.loc.gov/authorities/names/n2007043373">Memphis (Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.14953, -90.04898</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'mississippi')">
                <subject>
                    <geographic authority="naf" valueURI="http://id.loc.gov/authorities/names/n79138969">Mississippi</geographic>
                    <cartographics>
                        <coordinates>32.75041, -89.75036</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'mississippi delta')">
                <subject>
                    <geographic authority="lcsh" valueURI="http://id.loc.gov/authorities/subjects/sh91001124">Delta (Miss. : Region)</geographic>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'mississippi river')">
                <subject>
                    <geographic authority="lcsh" valueURI="http://id.loc.gov/authorities/subjects/sh85086206">Mississippi River</geographic>
                </subject>
            </xsl:when>
            <xsl:when test="contains($topic,'nashville') and contains($topic,'tennessee')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n78095801">Nashville (Tenn.)</geographic>
                    <cartographics>
                        <coordinates>36.16589, -86.78444</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'tennessee')">
                <subject>
                    <geographic authority="naf" valueURI="http://id.loc.gov/authorities/names/n79060965">Tennessee</geographic>
                </subject>
            </xsl:when>
            <xsl:when test="contains($topic,'tuscaloosa') and contains($topic,'alabama')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79133761">Tuscaloosa (Ala.)</geographic>
                    <cartographics>
                        <coordinates>33.20984, -87.56917</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="contains($topic,'washington') and contains($topic,'d.c.') or contains($topic,'dc') or contains($topic,'district of columbia') or matches($topic, 'washington (d.c.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79018774">Washington (D.C.)</geographic>
                    <cartographics>
                        <coordinates>38.89511, -77.03637</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:otherwise>
                <subject>
                    <geographic><xsl:value-of select="replace(replace(normalize-space(.), '\[', ''), '\]', '')"/></geographic>
                </subject>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>