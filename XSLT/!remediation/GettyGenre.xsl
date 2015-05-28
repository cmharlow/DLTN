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
            <xsl:when test="contains($genreterm, 'abstract')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026032">abstracts (summaries)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'account book')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027483">account books</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'account')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300145802">accounts</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'address book')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026689">address books</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'advertisement')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193993">advertisements</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'advertising card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300212151">advertising cards</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'aerial photograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128222">aerial photographs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'affidavit')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027594">affidavits</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'agenda')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027426">agendas (administrative records)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'album')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026690">albums (books)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'ambrotype')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127186">ambrotypes (photographs)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'application')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027002">application forms</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'appointment book')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026710">appointment books</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'apron')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300046131">aprons (protective wear)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'architectural drawing')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300034787">architectural drawings (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'armband')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300247490">armbands</genre>
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
            <xsl:when test="contains($genreterm, 'audit')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027475">audits</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'autobiograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300080104">autobiographies</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'autograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028571">autographs (manuscripts)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'award')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026842">awards</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'badge')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193994">badges</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'balance sheet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027486">balance sheets</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'ballot')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027428">ballots</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'bibliograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026497">bibliographies</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'biograph')">
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
            <xsl:when test="contains($genreterm, 'brochure')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300248280">brochures</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'business card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026767">business cards</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'card')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026756">cards (information artifacts)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'certificate')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026841">certificates</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'check')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300191339">checks (bank checks)</genre>
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
            <xsl:when test="contains($genreterm, 'computer disk')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300266292">hard disks</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'copy')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300257688">copies (document genres)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'correspondence')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026877">correspondence</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'daguerreotype case')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300261961">Union cases</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'digital image')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300215302">digital images</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'digital video')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300312050">digital moving image formats</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'directory')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026234">directories</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'document')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026030">documents</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'drawing')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033973">drawings (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'email')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300149026">electronic mail</genre>
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
            <xsl:when test="contains($genreterm, 'exam')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026936">examinations (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'fieldnotes')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027201">field notes</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'film')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300014637">film (material by form)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'flier') or contains($genreterm, 'flyer')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300224742">fliers (printed matter)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'folio')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300265438">folio (book format)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'form')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300049060">forms (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'government publication')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027777">government records</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'group portrait')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300124525">group portraits</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'handbill') or contains(lower-case(.), 'handout')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027033">handbills</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'handbook')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300311807">handbooks</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'illustration')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015578">illustrations (layout features)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'image')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300264387">images (object genre)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'index')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026554">indexes (reference sources)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'instruction')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027042">instructions (document genre)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'interview')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026392">interviews</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'invitation')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027083">invitations</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'kodachrome slide')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128371">slides (photographs)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'label')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028730">labels (identifying artifacts)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'leaflet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300211825">leaflets (printed works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'legal case and case notes')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'letterhead')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300193998">letterheads</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'letter')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026879">letters (correspondence)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'lithograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300041379">lithographs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'magazine')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300215389">magazines (periodicals)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'magnetic tape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028558">magnetic tapes</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'manual')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026395">manuals (instructional materials)</genre>
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
            <xsl:when test="contains($genreterm, 'memoir')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202559">memoirs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'memo')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026906">memorandums</genre>
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
            <xsl:when test="contains($genreterm, 'notes')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027200">notes</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'oral history')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300202595">oral histories (document genres)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'painting')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300033618">paintings (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'pamphlet') or contains(lower-case(.), 'pamplet')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300220572">pamphlets</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'paper')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300199056">papers (document genres)</genre>
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
            <xsl:when test="contains($genreterm, 'postage')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300037321">postage stamps</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'postcard')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026816">postcards</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'poster')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027221">posters</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'printed page')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300194222">pages (components)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'program')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027240">programs (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'receipt')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027573">receipts (financial records)</genre>
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
            <xsl:when test="contains($genreterm, 'slide')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300128371">slides (photographs)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'specification')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027723">specifications</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'speech')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300026671">speeches (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'stereograph')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300127197">stereographs</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'sticker')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300207379">stickers</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'survey')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300226986">surveys (documents)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'tape')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300014685">tape (materials)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'technical report')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027323">technical reports</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'text')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300263751">texts (document genres)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'thesis')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028028">theses</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'tickets')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300133073">admission tickets</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'tintype')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300134759">tintypes (prints)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'typescript')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028577">typescripts</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'video')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300028682">video recordings</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'views')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300015424">views (visual works)</genre>
            </xsl:when>
            <xsl:when test="contains($genreterm, 'voucher')">
                <genre authority="aat" valueURI="http://vocab.getty.edu/aat/300027574">vouchers (sales records)</genre>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>