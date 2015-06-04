<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="vLower" 
        select="'abcdefgijklmnopqrstuvwxyz'"/>
    <xsl:variable name="vUpper" 
        select="'ABCDEFGIJKLMNOPQRSTUVWXYZ'"/>
    
    <!-- lookup tables for most common AAT genre terms/URIs -->
    <xsl:template name="AATgenre">
        <xsl:param name="term"/>
        <xsl:variable name="genreterm" select="normalize-space(lower-case($term))"/>
        <xsl:choose>
            <xsl:when test="contains($genreterm, 'advertisement')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193993">advertisements</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'advertising card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300212151">advertising cards</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'aerial photograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128222">aerial photographs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'ambrotype')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127186">ambrotypes (photographs)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'application')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027002">application forms</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'architectural drawing')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300034787">architectural drawings (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'article')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300048715">articles</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'artifact')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300117127">artifacts (object genre)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'audio cassette')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028661">audiocassettes</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'audio')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028633">sound recordings</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'biography')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080102">biographies (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'booklet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311670">booklets</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'book')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028051">books</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'broadside')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026739">broadsides (notices)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026756">cards (information artifacts)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'catalog')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026059">catalogs (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'cityscape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015571">cityscapes (representations)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'clipping')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026867">clippings (information artifacts)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'correspondence')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026877">correspondence</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'daguerreotype case')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300261961">Union cases</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'document')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026030">documents</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'drawing')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033973">drawings (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'envelope')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300197601">envelopes</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'ephemera')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028881">ephemera (general)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'etching')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300041365">etchings (prints)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'folio')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300265438">folio (book format)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'group portrait')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300124525">group portraits</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'illustration')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015578">illustrations (layout features)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'interview')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'kodachrome slide')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128371">slides (photographs)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'letterhead')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193998">letterheads</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'lithograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300041379">lithographs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'magazine')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300215389">magazines (periodicals)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'manuscript')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028569">manuscripts (document genre)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'map')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028094">maps (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'medallion')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300077357">medallions (medals)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'miniature')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033936">miniatures (paintings)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'newsletter')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026652">newsletters</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'newspaper')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026656">newspapers</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'painting')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033618">paintings (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'pamphlet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'panoramic photograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015537">panoramas</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'periodical')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026657">periodicals</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'photograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046300">photographs</genre>
            </xsl:when>
            <xsl:when test="matches($genreterm, 'pin')"><!-- not sure what kind of pin is meant -->
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311889">objects</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'portrait')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015637">portraits</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'postcard')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'printed page')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300194222">pages (components)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'programs')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'rendering')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300034727">renderings (drawings)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'report')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027267">reports</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'scrapbook')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027341">scrapbooks</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'sheet music')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026430">sheet music</genre>
            </xsl:when>
            <xsl:when test="$genreterm='signs'">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300123013">signs (declatory or advertising artifacts)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'sketchbook')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027354">sketchbooks</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'specification')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027723">specifications</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'stereograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127197">stereographs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'tintype')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300134759">tintypes (prints)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'typescript')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028577">typescripts</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'views')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015424">views (visual works)</genre>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>