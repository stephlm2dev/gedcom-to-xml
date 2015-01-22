<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" 
              encoding="UTF-8"
              version="4.0"
              indent="yes"/>

  <!-- ######################## KEYS ######################## -->
  <xsl:key name="family-search" match="family" use="@id"/>
  <xsl:key name="individual-search" match="individual" use="@id"/>
  <xsl:key name="husband-search" match="husband" use="@idref"/>
  <xsl:key name="wife-search" match="wife" use="@idref"/>

  <!-- ######################## CHILDREN ######################## -->
  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="count(./*) > 0">
        <xsl:apply-templates select="*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="starts-with(., 'http')">
            <xsl:call-template name="idref">
              <xsl:with-param name="link" select="."/>
            </xsl:call-template> 
          </xsl:when>
          <xsl:when test="contains(., '>>')">
            <xsl:call-template name="string-replace-all">
              <xsl:with-param name="text" select="."/>
              <xsl:with-param name="replace" select="'>>'"/>
              <xsl:with-param name="by" select="''"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
        
        <xsl:element name="br"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ######################## HEADER ######################## -->
  <xsl:template match="//header">
    <xsl:element name="tr">

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="source"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="destination"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="date"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="charset"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="file"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="gedcom"/>
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <!-- ######################## SUBMITTER ######################## -->
  <xsl:template match="//submitter">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id"/>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="name"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="address"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="phone"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="comment"/>
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <!-- ######################## FAMILLE ######################## -->
  <xsl:template match="//family">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id"/>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="husband"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="wife"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="child">
          <xsl:call-template name="individualTemplate">
            <xsl:with-param name="title" select="child"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="individualTemplate">
            <xsl:with-param name="title" select="children"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="divorce"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="marriage"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="object"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="source"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="change"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="number"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="miscellaneous"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="engagement"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="annulment"/>
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <!-- ######################## INDIVIDU ######################## -->
  <xsl:template match="//individual" mode="index">
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">
          #<xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:value-of select="name"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//individual" mode="details">
      <xsl:variable name="fams" select=".//fams/@idref"/>
      <xsl:variable name="family-element" select="key('family-search', $fams)"/>

    <xsl:element name="tr">
      <xsl:element name="td">
        <xsl:value-of select="name"/> 
      </xsl:element>
      <xsl:element name="td">

        <xsl:variable name="husbandFams" select="key('husband-search', @id)/../wife/@idref"/>
        <xsl:variable name="wifeFams" select="key('wife-search', @id)/../husband/@idref"/>

        <xsl:variable name="husbandWifeFams">
          <xsl:if test="$husbandFams != '' ">
            <xsl:call-template name="join">
              <xsl:with-param name="valueList" select="$husbandFams"/>
              <xsl:with-param name="separator" select="' '"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$wifeFams != '' ">
            <xsl:call-template name="join">
              <xsl:with-param name="valueList" select="$wifeFams"/>
              <xsl:with-param name="separator" select="' '"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:variable>

        <xsl:call-template name="idrefsTemplate">
          <xsl:with-param name="links" select="$husbandWifeFams"/>
        </xsl:call-template>

      </xsl:element>
      <xsl:element name="td">
        <xsl:variable name="childFams" select="$family-element/child/@idref"/>
        <xsl:variable name="childrenFams" select="$family-element/children/@idrefs"/>

        <xsl:call-template name="idrefsTemplate">
          <xsl:with-param name="links" select="$childrenFams|$childFams"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//individual">
    <xsl:element name="tr">
      <xsl:apply-templates select="@id"/>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="title"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="name"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="sex"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="source"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="change"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="number"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="birth"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="christening"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="baptism"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="miscellaneous"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="attribute"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="occupation"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="death"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="burial"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="reference"/>
      </xsl:call-template>

       <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="famc"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="fams"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="object"/>
      </xsl:call-template>

      <xsl:call-template name="individualTemplate">
        <xsl:with-param name="title" select="note"/>
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <!-- ######################## TEMPLATE ######################## -->
  <xsl:template name="individualTemplate">
    <xsl:param name="title"/>
    <xsl:element name="td">
      <xsl:choose>
        <xsl:when test="count($title) != 0">
          <xsl:choose>
             <xsl:when test="$title/@idref">
              <xsl:apply-templates select="$title/@idref"/>
            </xsl:when>
            <xsl:when test="$title/@idrefs">
              <xsl:call-template name="idrefsTemplate">
                <xsl:with-param name="links" select="$title/@idrefs"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$title"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#216;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template name="idrefsTemplate">
    <xsl:param name="links"/>

    <xsl:choose>
      <xsl:when test="not($links)">
        <xsl:text>&#216;</xsl:text>
      </xsl:when>
      <xsl:when test="contains($links, ' ')">
        <xsl:call-template name="idref">
          <xsl:with-param name="link" select="substring-before($links,' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="idref">
          <xsl:with-param name="link" select="$links"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="substring-after($links,' ') != ''">
      <xsl:element name="br"/>
      <xsl:call-template name="idrefsTemplate">
        <xsl:with-param name="links" select="substring-after($links,' ')"/>
      </xsl:call-template>     
    </xsl:if>
  </xsl:template>

  <!-- http://stackoverflow.com/questions/3067113/xslt-string-replace -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$by"/>
        <xsl:element name="br"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="by" select="$by"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- http://www.codemeit.com/xml/xslt-10-join-a-list-of-elementss-value-with-separator.html -->
  <xsl:template name="join" >
    <xsl:param name="valueList" select="''"/>
    <xsl:param name="separator" select="','"/>
    <!-- <xsl:if test="$valueList != '' "> -->
      <xsl:for-each select="$valueList">
        <xsl:choose>
          <xsl:when test="position() = 1">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($separator, .) "/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    <!-- </xsl:if> -->
  </xsl:template>

  <!-- ######################## ID/IDREF ######################## -->
  <xsl:template match="@id">
    <xsl:element name="th">
      <xsl:attribute name="id">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="idref" match="@idref">
    <xsl:param name="link"/>

    <xsl:variable name="url" as="xsd:string">
      <xsl:choose>
        <xsl:when test="name() = 'idref' ">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$link"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:if test="not(starts-with($url, 'http'))">#</xsl:if>
        <xsl:value-of select="$url"/>
      </xsl:attribute>
      <xsl:text> </xsl:text>
      
      <xsl:choose>
        <xsl:when test="starts-with($url, 'I') or starts-with($url, 'R')">
          <!-- <xsl:value-of select="//individual[@id = $url]/name"/> -->
          <xsl:value-of select="key('individual-search', $url)/name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$url"/>
        </xsl:otherwise>       
      </xsl:choose>
      
    </xsl:element>
  </xsl:template>

  <!-- ######################## TEMPLATE PRINCIPAL ######################## -->
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:attribute name="lang">fr</xsl:attribute>
      <xsl:element name="head">
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="href">style.css</xsl:attribute>
        </xsl:element>
        <xsl:element name="title"> Gedcom </xsl:element>
      </xsl:element>

      <xsl:element name="body">
        <!-- THE TEMPLATE FOR INDIVIDU/FAMILY AND OTHERS -->
        <xsl:element name="h1">Arbre généalogique</xsl:element>

        <xsl:if test="count(//header/*) > 0">
          <xsl:element name="h2"> HEAD </xsl:element>
          <xsl:element name="table">
            <xsl:element name="tr">
              <xsl:element name="th">Source</xsl:element>
              <xsl:element name="th">Destination</xsl:element>
              <xsl:element name="th">Date</xsl:element>
              <xsl:element name="th">Charset</xsl:element>
              <xsl:element name="th">File</xsl:element>
              <xsl:element name="th">Gedcom</xsl:element>
            </xsl:element>
            <xsl:apply-templates select="//header"/>
          </xsl:element>
        </xsl:if>
 
        <xsl:if test="count(//submitter/*) > 0">
          <xsl:element name="h2"> SUBMITTER </xsl:element>
          <xsl:element name="table">
            <xsl:element name="tr">
              <xsl:element name="th">ID</xsl:element>
              <xsl:element name="th">Name</xsl:element>
              <xsl:element name="th">Address</xsl:element>
              <xsl:element name="th">Phone</xsl:element>
              <xsl:element name="th">Comment</xsl:element>
            </xsl:element>
            <xsl:apply-templates select="//submitter"/>
          </xsl:element>
        </xsl:if>

        <xsl:element name="h2">FAMILLE</xsl:element>
        <xsl:element name="table">
          <xsl:element name="tr">
            <xsl:element name="th">ID</xsl:element>
            <xsl:element name="th">Husband</xsl:element>
            <xsl:element name="th">Wife</xsl:element>
            <xsl:element name="th">Children</xsl:element>
            <xsl:element name="th">Divorce</xsl:element>
            <xsl:element name="th">Marriage</xsl:element>
            <xsl:element name="th">Object</xsl:element>
            <xsl:element name="th">Source</xsl:element>
            <xsl:element name="th">Change</xsl:element>
            <xsl:element name="th">Number</xsl:element>
            <xsl:element name="th">Miscellaneous</xsl:element>
            <xsl:element name="th">Engagement</xsl:element>
            <xsl:element name="th">Annulment</xsl:element>
          </xsl:element>
          <xsl:apply-templates select="//family"/>
        </xsl:element>

        <xsl:element name="h2">INDIVIDU</xsl:element>
        <xsl:element name="table">
          <xsl:element name="tr">
            <xsl:element name="th">ID</xsl:element>
            <xsl:element name="th">Title</xsl:element>
            <xsl:element name="th">Name</xsl:element>
            <xsl:element name="th">Sex</xsl:element>
            <xsl:element name="th">Source</xsl:element>
            <xsl:element name="th">Change</xsl:element>
            <xsl:element name="th">Number</xsl:element>
            <xsl:element name="th">Birth</xsl:element>
            <xsl:element name="th">Christening</xsl:element>
            <xsl:element name="th">Baptism</xsl:element>
            <xsl:element name="th">Miscellaneous</xsl:element>
            <xsl:element name="th">Attribute</xsl:element>
            <xsl:element name="th">Occupation</xsl:element>
            <xsl:element name="th">Death</xsl:element>
            <xsl:element name="th">Burial</xsl:element>
            <xsl:element name="th">Reference</xsl:element>
            <xsl:element name="th">Famc</xsl:element>
            <xsl:element name="th">Fams</xsl:element>
            <xsl:element name="th">Object</xsl:element>
            <xsl:element name="th">Note</xsl:element>
          </xsl:element>
          <xsl:apply-templates select="//individual"/>
        </xsl:element>

        <xsl:element name="h2">DETAILS INDIVIDU</xsl:element>
        <xsl:element name="table">
          <xsl:element name="tr">
            <xsl:element name="th">Name</xsl:element>
            <xsl:element name="th">Conjunct(s)</xsl:element>
            <xsl:element name="th">Children</xsl:element>
          </xsl:element>
          <xsl:apply-templates select="//individual" mode="details"/>
        </xsl:element>
        
        <xsl:element name="h2">INDEX</xsl:element>
        <xsl:element name="ol">
          <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
          <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
          <xsl:apply-templates select="//individual" mode="index">
            <xsl:sort select="substring-after(translate(name, $smallcase, $uppercase), '/')" order="ascending"/>
            <xsl:sort select="substring-before(name, '/')" order="ascending"/>
          </xsl:apply-templates>
        </xsl:element>

      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
