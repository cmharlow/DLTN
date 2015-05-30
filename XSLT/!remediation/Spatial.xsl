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
            <xsl:when test="contains(normalize-space(lower-case(.)),'evergreen') and contains(normalize-space(lower-case(.)),'memphis') and contains(normalize-space(lower-case(.)),'tennessee')">
                <subject>
                    <geographic>Evergreen Historic District (Memphis, Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.1479, -90.0072</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            
            <!-- Cities, States, Countries, etc. -->
            <xsl:when test="(contains(normalize-space(lower-case(.)),'albany') and contains(normalize-space(lower-case(.)),'georgia')) or matches(., 'albany (ga.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n81107844">Albany (Ga.)</geographic>
                    <cartographics>
                        <coordinates>31.57851, -84.15574</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'alcoa') and contains(normalize-space(lower-case(.)),'tennessee')) or matches(., 'alcoa (tenn.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n80022862">Alcoa (Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.78953, -83.97379</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'alexandria') and contains(normalize-space(lower-case(.)),'virginia')) or matches(., 'alexandria (va.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79099306">Alexandria (Va.)</geographic>
                    <cartographics>
                        <coordinates>38.80484, -77.04692</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'anderson') and contains(normalize-space(lower-case(.)),'indiana')) or matches(., 'anderson (ind.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n50074868">Anderson (Ind.)</geographic>
                    <cartographics>
                        <coordinates>40.10532, -85.68025</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'atlanta') and contains(normalize-space(lower-case(.)),'georgia')) or matches(., 'atlanta (ga.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79023214">Atlanta (Ga.)</geographic>
                    <cartographics>
                        <coordinates>33.749, -84.38798</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'attala') and contains(normalize-space(lower-case(.)),'mississippi')) or matches(., 'attala county (miss.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n82101331">Attala County (Miss.)</geographic>
                    <cartographics>
                        <coordinates>33.08629, -89.58155</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'brownsville') and contains(normalize-space(lower-case(.)),'tennessee')) or matches(., 'brownsville (tenn.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n84008639">Brownsville (Tenn.)</geographic>
                    <cartographics>
                        <coordinates>35.59397, -89.26229</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'birmingham') and contains(normalize-space(lower-case(.)),'alabama')) or matches(., 'birmingham (ala.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79042167">Birmingham (Ala.)</geographic>
                    <cartographics>
                        <coordinates>33.52066, -86.80249</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'boston') and contains(normalize-space(lower-case(.)),'massachusetts')) or matches(., 'boston (mass.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79045553">Boston (Mass.)</geographic>
                    <cartographics>
                        <coordinates>42.35843, -71.05977</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'chicago') and contains(normalize-space(lower-case(.)),'illinois')) or matches(., 'chicago (ill.)')">
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
            <xsl:when test="(contains(normalize-space(lower-case(.)),'hoxie') and contains(normalize-space(lower-case(.)),'arkansas')) or matches(., 'hoxie (ark.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n83030241">Hoxie (Ark.)</geographic>
                    <cartographics>
                        <coordinates>36.05035, -90.97512</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="(contains(normalize-space(lower-case(.)),'macon') and contains(normalize-space(lower-case(.)),'georgia')) or matches(., 'macon (ga.)')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79133192">Macon (Ga.)</geographic>
                    <cartographics>
                        <coordinates>32.84069, -83.6324</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="matches($topic, 'memphis') or matches($topic, 'memphis, tenn.') or matches(., 'memphis (tenn.)') or (contains(normalize-space(lower-case(.)),'memphis') and contains(normalize-space(lower-case(.)),'tennessee'))">
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
            <xsl:when test="contains(normalize-space(lower-case(.)),'nashville') and contains(normalize-space(lower-case(.)),'tennessee')">
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
            <xsl:when test="contains(normalize-space(lower-case(.)),'tuscaloosa') and contains(normalize-space(lower-case(.)),'alabama')">
                <subject>
                    <geographic authority="lcnaf" valueURI="http://id.loc.gov/authorities/names/n79133761">Tuscaloosa (Ala.)</geographic>
                    <cartographics>
                        <coordinates>33.20984, -87.56917</coordinates>
                    </cartographics>
                </subject>
            </xsl:when>
            <xsl:when test="contains(normalize-space(lower-case(.)),'washington') and contains(normalize-space(lower-case(.)),'d.c.') or contains(normalize-space(lower-case(.)),'dc') or contains(normalize-space(lower-case(.)),'district of columbia') or matches(., 'washington (d.c.)')">
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