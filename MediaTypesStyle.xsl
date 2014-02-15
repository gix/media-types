<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings">
  <xsl:output method="html" doctype-system="about:legacy-compat"/>

  <!-- The top-level element -->
  <xsl:template match="MediaTypes">
    <html>
      <head>
        <title>Media Foundation and DirectShow Media Types</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link href="MediaTypesStyle.css" type="text/css" rel="stylesheet"/>
      </head>
      <body>
        <h1>Media Foundation and DirectShow Media Types</h1>
        <p class="revision">Revision <xsl:value-of select="@Revision"/></p>
        <div class="toc">
          <h2>Table of Contents</h2>
          <ul>
            <li>
              <a href="#containers">Containers</a> (<xsl:value-of select="count(Containers//Container)"/>)
            </li>
            <li>
              <a href="#major-types">Major types</a> (<xsl:value-of select="count(MajorTypes//MajorType)"/>)
            </li>
            <li class="horz">
              <a href="#formats">Formats</a> (<xsl:value-of select="count(Formats//MajorType) + count(Formats//Format) + count(Formats//VideoFormat) + count(Formats//PixelFormat) + count(Formats//AudioFormat) + count(Formats//SubtitleFormat)"/>)
              <ul>
                <li>
                  <a href="#video-formats">Video</a> (<xsl:value-of select="count(Formats//VideoFormat)"/>)
                  <ul>
                    <xsl:for-each select="Formats/VideoFormatGroup">
                      <xsl:sort select="@Name"/>
                      <li>
                        <a href="#{generate-id(.)}"><xsl:value-of select="@Name"/></a> (<xsl:value-of select="count(VideoFormat)"/>)
                      </li>
                    </xsl:for-each>
                  </ul>
                </li>
                <li>
                  <a href="#audio-formats">Audio</a> (<xsl:value-of select="count(Formats//AudioFormat)"/>)
                  <ul>
                    <xsl:for-each select="Formats/AudioFormatGroup">
                      <xsl:sort select="@Name"/>
                      <li>
                        <a href="#{generate-id(.)}"><xsl:value-of select="@Name"/></a> (<xsl:value-of select="count(AudioFormat)"/>)
                      </li>
                    </xsl:for-each>
                  </ul>
                </li>
                <li>
                  <a href="#subtitle-formats">Subtitles</a> (<xsl:value-of select="count(Formats//SubtitleFormat)"/>)
                </li>
                <li>
                  <a href="#pixel-formats">Pixel formats</a> (<xsl:value-of select="count(Formats//PixelFormat)"/>)
                  <ul>
                    <xsl:for-each select="Formats/PixelFormatGroup">
                      <li>
                        <a href="#{generate-id(.)}"><xsl:value-of select="@Name"/></a> (<xsl:value-of select="count(PixelFormat)"/>)
                      </li>
                    </xsl:for-each>
                  </ul>
                </li>
              </ul>
            </li>
            <li class="horz">
              <a href="#caps">Caps</a>
              <ul>
                <li>
                  <a href="#dxva">DXVA</a> (<xsl:value-of select="count(Caps//DxvaMode)"/>)
                  <ul>
                    <xsl:for-each select="Caps/DxvaModeGroup">
                      <xsl:sort select="@Name"/>
                      <li>
                        <a href="#{generate-id(.)}"><xsl:value-of select="@Name"/></a> (<xsl:value-of select="count(DxvaMode)"/>)
                      </li>
                    </xsl:for-each>
                  </ul>
                </li>
              </ul>
            </li>
          </ul>
        </div>
        <xsl:apply-templates/>
        <xsl:call-template name="Mappings"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Containers">
    <h2 id="containers">Containers</h2>
    <table class="list">
      <thead>
        <tr>
          <th>Name</th>
          <th>Extension</th>
          <th><dfn title="InternetMediaType">IMT</dfn></th>
          <th>FourCC</th>
          <th>Guid</th>
          <th>Standard</th>
          <th>Check bytes</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="Container">
          <tr>
            <td><xsl:value-of select="@Name"/></td>
            <td>
              <xsl:call-template name="StringList">
                <xsl:with-param name="string"><xsl:value-of select="@Extension"/></xsl:with-param>
              </xsl:call-template>
            </td>
            <td><xsl:call-template name="InternetMediaType"/></td>
            <td><xsl:call-template name="FourCC"/></td>
            <td><xsl:call-template name="Guids"/></td>
            <td><xsl:value-of select="@Spec"/></td>
            <td>
              <xsl:for-each select="CheckBytes">
                <xsl:value-of select="@Value"/><br/>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="MajorTypes">
    <h2 id="major-types">Major types</h2>

    <table class="list">
      <thead>
        <tr>
          <th>Name</th>
          <th>FourCC</th>
          <th>Guid</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="MajorType">
          <tr>
            <td><xsl:value-of select="@Name"/></td>
            <td><xsl:call-template name="FourCC"/></td>
            <td><xsl:call-template name="Guids"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="Formats">
    <h2 id="formats">Formats</h2>

    <table class="list" id="misc-formats">
      <caption>Uncategorized formats</caption>
      <thead>
        <tr>
          <th>Name</th>
          <th>FourCC</th>
          <th>Guid</th>
          <th><dfn title="libavformat CodecId">LAVID</dfn></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="Format">
          <tr>
            <td><xsl:value-of select="@Name"/></td>
            <td><xsl:call-template name="FourCC"/></td>
            <td><xsl:call-template name="Guids"/></td>
            <td><xsl:call-template name="LavCodecId"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>

    <table class="list" id="video-formats">
      <caption>Video formats</caption>
      <thead>
        <xsl:call-template name="VideoFormatHeader"/>
      </thead>
      <tbody>
        <xsl:apply-templates select="VideoFormat|VideoFormatGroup"/>
      </tbody>
    </table>

    <table class="list" id="audio-formats">
      <caption>Audio formats</caption>
      <thead>
        <xsl:call-template name="AudioFormatHeader"/>
      </thead>
      <tbody>
        <xsl:apply-templates select="AudioFormat|AudioFormatGroup"/>
      </tbody>
    </table>

    <table class="list" id="subtitle-formats">
      <caption>Subtitle formats</caption>
      <thead>
        <xsl:call-template name="SubtitleFormatHeader"/>
      </thead>
      <tbody>
        <xsl:apply-templates select="SubtitleFormat|SubtitleFormatGroup"/>
      </tbody>
    </table>

    <table class="list" id="pixel-formats">
      <caption>Pixel formats</caption>
      <thead>
        <xsl:call-template name="PixelFormatHeader"/>
      </thead>
      <tbody>
        <xsl:apply-templates select="PixelFormat|PixelFormatGroup"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="Caps">
    <h2 id="caps">Caps</h2>

    <table class="list" id="dxva">
      <caption>DXVA</caption>
      <thead>
        <xsl:call-template name="DxvaModeHeader"/>
      </thead>
      <tbody>
        <xsl:apply-templates select="DxvaMode|DxvaModeGroup"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="Sources">
    <h2 id="sources">Sources</h2>

    <table class="list">
      <thead>
        <tr>
          <th>Title</th>
          <th>Vendor</th>
          <th>Date</th>
          <th>File</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="Source">
          <tr id="source-{@Id}">
            <td><xsl:value-of select="@Title"/></td>
            <td><xsl:value-of select="@Vendor"/></td>
            <td><xsl:value-of select="@Date"/></td>
            <td><xsl:value-of select="@File"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="SourceNote">
    <xsl:if test="@Source">
      <sup><a href="#source-{@Source}">[<xsl:value-of select="@Source"/>]</a></sup>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Mappings">
    <h2>Mappings</h2>

    <!--
    <h3>FourCC</h3>
    <pre><code>
      <xsl:text>enum FourCC&#xA;{&#xA;</xsl:text>
      <xsl:for-each select="Formats//VideoFormat[@FourCC]">
        <xsl:sort select="substring(@FourCC,14,4)"/>
        <xsl:text>    FourCC_</xsl:text>
        <xsl:value-of select="substring(@FourCC,14,4)"/>
        <xsl:text> = </xsl:text>
        <xsl:value-of select="substring(@FourCC,0,11)"/>
        <xsl:text>,&#xA;</xsl:text>
      </xsl:for-each>
      <xsl:text>};&#xA;</xsl:text>
    </code></pre>
    -->

    <!--
    <h3>LAV CodecId Mapping</h3>
    <pre><code>
      <xsl:for-each select="Formats/VideoFormatGroup[VideoFormat[@LavCodecId][@FourCC]]">
        <xsl:text>// </xsl:text><xsl:value-of select="@Name"/><xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="VideoFormat[@LavCodecId][@FourCC]">
          <xsl:sort select="substring(@FourCC,14,4)"/>
          <xsl:if test="count(@MFGuid) = 0">
            <xsl:text>DEFINE_MEDIATYPE_GUID(MFVideoFormat_</xsl:text>
            <xsl:value-of select="substring(@FourCC,14,4)"/>
            <xsl:text>, FCC('</xsl:text>
            <xsl:value-of select="substring(@FourCC,14,4)"/>
            <xsl:text>'));&#xA;</xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
      </xsl:for-each>
    </code></pre>

    <pre><code>
      <xsl:text>static LavVideoFormatPair g_LavVideoFormatMap[] =&#xA;{&#xA;</xsl:text>
      <xsl:for-each select="Formats/VideoFormatGroup[VideoFormat[@LavCodecId][@FourCC]]">
        <xsl:text>    // </xsl:text><xsl:value-of select="@Name"/><xsl:text>&#xA;</xsl:text>
        <xsl:for-each select="VideoFormat[@LavCodecId][@FourCC]">
          <xsl:text>    { </xsl:text>
          <xsl:choose>
            <xsl:when test="count(@MFGuid) &gt; 0">
              <xsl:text>&amp;</xsl:text>
              <xsl:value-of select="substring(@MFGuid, 41, string-length(@MFGuid) - 41)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&amp;MFVideoFormat_</xsl:text><xsl:value-of select="substring(@FourCC,14,4)"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="@LavCodecId"/>
          <xsl:text> },&#xA;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
      </xsl:for-each>
      <xsl:text>};&#xA;</xsl:text>
    </code></pre>
    -->

    <table class="list">
      <caption>LAV CodecId Mapping</caption>
      <thead>
        <tr>
          <th>Name</th>
          <th>FourCC</th>
          <th><dfn title="MediaType GUID">Guid</dfn></th>
          <th><dfn title="libavformat CodecId">LAVID</dfn></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="Formats//VideoFormat[@LavCodecId]">
          <xsl:sort select="@LavCodecId"/>
          <tr>
            <td><xsl:value-of select="@Name"/></td>
            <td><xsl:call-template name="FourCC"/></td>
            <td>
              <xsl:call-template name="Guids"/>
            </td>
            <td><xsl:call-template name="LavCodecId"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="FourCC">
    <span class="fourcc"><xsl:value-of select="@FourCC"/></span>
  </xsl:template>

  <xsl:template name="ScopeTag">
    <xsl:choose>
      <xsl:when test="@Scope = 'MF'">
        <dfn class="tag tag-mf" title="MediaFoundation MediaType GUID">MF</dfn>
      </xsl:when>
      <xsl:when test="@Scope = 'DS'">
        <dfn class="tag tag-ds" title="DirectShow MediaType GUID">DS</dfn>
      </xsl:when>
      <xsl:when test="@Scope = 'KS'">
        <dfn class="tag tag-ks" title="Kernel Streaming SubType GUID">KS</dfn>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="DxvaVersionTag">
    <xsl:choose>
      <xsl:when test="@Version = '1'">
        <dfn class="tag tag-dxva1" title="DXVA1">DX1</dfn>
      </xsl:when>
      <xsl:when test="@Version = '2'">
        <dfn class="tag tag-dxva2" title="DXVA2">DX2</dfn>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="D3DVersionTag">
    <xsl:choose>
      <xsl:when test="@D3DVersion = '11'">
        <dfn class="tag tag-d3d" title="Direct3D 11 Video API">D3D11</dfn>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Guid">
    <div>
      <span class="guid">
        <xsl:value-of select="@Id"/>
        (<xsl:value-of select="@Name"/>)<xsl:call-template name="ScopeTag"/>
        <xsl:choose>
          <xsl:when test="@Source = 'Microsoft'">
            <dfn class="tag tag-official" title="Microsoft-specified Guid">MS</dfn>
          </xsl:when>
        </xsl:choose>
      </span>
    </div>
  </xsl:template>

  <xsl:template name="Guids">
    <xsl:apply-templates select="Guid"/>
  </xsl:template>

  <xsl:template match="DxvaId">
    <div>
      <span class="guid">
        <xsl:value-of select="@Id"/>
        (<xsl:value-of select="@Name"/>)<xsl:call-template name="DxvaVersionTag"/>
        <xsl:if test="@Source = 'Microsoft'">
          <dfn class="tag tag-official" title="Microsoft-specified Guid">MS</dfn>
        </xsl:if>
        <xsl:call-template name="D3DVersionTag"/>
      </span>
    </div>
  </xsl:template>

  <xsl:template name="DxvaIds">
    <xsl:apply-templates select="DxvaId"/>
  </xsl:template>

  <xsl:template name="InternetMediaType">
    <xsl:for-each select="str:split(@InternetMediaType, ';')">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <span class="media-type"><xsl:value-of select="."/></span>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="StringList">
    <xsl:param name="string"/>
    <xsl:for-each select="str:split($string, ';')">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="WaveFormat">
    <span class="wave-format"><xsl:value-of select="@WaveFormat"/></span>
  </xsl:template>

  <xsl:template name="LavCodecId">
    <xsl:for-each select="str:split(@LavCodecId, ';')">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="starts-with(.,'AV_CODEC_ID_')">
          <dfn class="codec-id" title="{.}"><xsl:value-of select="substring(., 13, string-length(.) - 12)"/></dfn>
        </xsl:when>
        <xsl:otherwise>
          <span class="codec-id"><xsl:value-of select="."/></span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="LavPixelFmt">
    <xsl:choose>
      <xsl:when test="starts-with(@LavPixelFmt,'AV_PIX_FMT_')">
        <span class="pixel-format-id" title="{@LavPixelFmt}"><xsl:value-of select="substring(@LavPixelFmt, 12, string-length(@LavPixelFmt) - 11)"/></span>
      </xsl:when>
      <xsl:otherwise>
        <span class="pixel-format-id"><xsl:value-of select="@LavPixelFmt"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="MatroskaCodecId">
    <span class="codec-id"><xsl:value-of select="@MatroskaCodecId"/></span>
  </xsl:template>

  <xsl:template name="AttributeTitles">
    <xsl:choose>
      <xsl:when test="@Obsolete and @Duplicate">
        <xsl:attribute name="title">Obsolete, Duplicate</xsl:attribute>
      </xsl:when>
      <xsl:when test="@Obsolete">
        <xsl:attribute name="title">Obsolete</xsl:attribute>
      </xsl:when>
      <xsl:when test="@Duplicate">
        <xsl:attribute name="title">Duplicate</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="VideoFormatHeader">
    <tr class="sub">
      <th>Name</th>
      <th>FourCC</th>
      <th>Guid</th>
      <th><dfn title="libavformat CodecId">LAVID</dfn></th>
      <th><dfn title="Matroska CodecId">MKVID</dfn></th>
      <th>Notes</th>
    </tr>
  </xsl:template>
  <xsl:template match="VideoFormatGroup">
    <tr>
      <th colspan="6" id="{generate-id(.)}">
        <xsl:value-of select="@Name"/>
      </th>
    </tr>
    <xsl:call-template name="VideoFormatHeader"/>
    <xsl:apply-templates select="VideoFormat"/>
    <xsl:if test="not(following-sibling::*[1][self::VideoFormatGroup])">
      <tr>
        <th colspan="6" class="subsub"></th>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="VideoFormat">
    <tr class="{@Obsolete} {@Duplicate}">
      <xsl:call-template name="AttributeTitles"/>
      <td><xsl:value-of select="@Name"/></td>
      <td><xsl:call-template name="FourCC"/></td>
      <td><xsl:call-template name="Guids"/></td>
      <td><xsl:call-template name="LavCodecId"/></td>
      <td><xsl:call-template name="MatroskaCodecId"/></td>
      <td><xsl:value-of select="@Notes"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="AudioFormatHeader">
    <tr class="sub">
      <th>Name</th>
      <th>FourCC</th>
      <th>Guid</th>
      <th>WaveFormat</th>
      <th><dfn title="libavformat CodecId">LAVID</dfn></th>
      <th><dfn title="Matroska CodecId">MKVID</dfn></th>
      <th>Notes</th>
    </tr>
  </xsl:template>
  <xsl:template match="AudioFormatGroup">
    <tr>
      <th colspan="9" id="{generate-id(.)}">
        <xsl:value-of select="@Name"/>
      </th>
    </tr>
    <xsl:call-template name="AudioFormatHeader"/>
    <xsl:apply-templates select="AudioFormat"/>
    <xsl:if test="not(following-sibling::*[1][self::AudioFormatGroup])">
      <tr>
        <th colspan="9" class="subsub"></th>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="AudioFormat">
    <tr class="{@Obsolete} {@Duplicate}">
      <xsl:call-template name="AttributeTitles"/>
      <td><xsl:value-of select="@Name"/></td>
      <td><xsl:call-template name="FourCC"/></td>
      <td><xsl:call-template name="Guids"/></td>
      <td><xsl:call-template name="WaveFormat"/></td>
      <td><xsl:call-template name="LavCodecId"/></td>
      <td><xsl:call-template name="MatroskaCodecId"/></td>
      <td><xsl:value-of select="@Notes"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="SubtitleFormatHeader">
    <tr class="sub">
      <th>Name</th>
      <th>Extension</th>
      <th>FourCC</th>
      <th>Guid</th>
      <th><dfn title="libavformat CodecId">LAVID</dfn></th>
      <th><dfn title="Matroska CodecId">MKVID</dfn></th>
      <th>Notes</th>
    </tr>
  </xsl:template>
  <xsl:template match="SubtitleFormat">
    <tr>
      <td><xsl:value-of select="@Name"/></td>
      <td><xsl:value-of select="@Extension"/></td>
      <td><xsl:call-template name="FourCC"/></td>
      <td><xsl:call-template name="Guids"/></td>
      <td><xsl:call-template name="LavCodecId"/></td>
      <td><xsl:call-template name="MatroskaCodecId"/></td>
      <td><xsl:value-of select="@Notes"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="PixelFormatHeader">
    <tr>
      <th>Name</th>
      <th>FourCC</th>
      <th>Guid</th>
      <th>Sampling</th>
      <th>Mode</th>
      <th><abbr title="bits per pixel">bpp</abbr></th>
      <th><abbr title="bits per channel">bpc</abbr></th>
      <th><dfn title="libavformat AVPixelFormat">LAVPF</dfn></th>
      <th>Notes</th>
    </tr>
  </xsl:template>
  <xsl:template match="PixelFormatGroup">
    <tr>
      <th colspan="9" id="{generate-id(.)}" class="subsub">
        <xsl:value-of select="@Name"/>
      </th>
    </tr>
    <xsl:apply-templates select="PixelFormat"/>
    <xsl:if test="not(following-sibling::*[1][self::PixelFormatGroup])">
      <tr>
        <th colspan="9" class="subsub"></th>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="PixelFormat">
    <tr>
      <td><xsl:value-of select="@Name"/></td>
      <td><xsl:call-template name="FourCC"/></td>
      <td><xsl:call-template name="Guids"/></td>
      <td><xsl:value-of select="@Sampling"/></td>
      <td><xsl:value-of select="@Mode"/></td>
      <td><xsl:value-of select="@BitsPerPixel"/></td>
      <td><xsl:value-of select="@BitsPerChannel"/></td>
      <td><xsl:call-template name="LavPixelFmt"/></td>
      <td><xsl:value-of select="@Notes"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="DxvaModeHeader">
    <tr class="sub">
      <th>Name</th>
      <th>Id</th>
      <th><dfn title="libavformat CodecId">LAVID</dfn></th>
    </tr>
  </xsl:template>
  <xsl:template match="DxvaModeGroup">
    <tr>
      <th colspan="10" id="{generate-id(.)}">
        <xsl:value-of select="@Name"/>
      </th>
    </tr>
    <xsl:apply-templates select="DxvaMode"/>
    <xsl:if test="not(following-sibling::*[1][self::DxvaModeGroup])">
      <tr>
        <th colspan="3" class="subsub"></th>
      </tr>
    </xsl:if>
  </xsl:template>
  <xsl:template match="DxvaMode">
    <tr class="{@Obsolete} {@Duplicate}">
      <xsl:call-template name="AttributeTitles"/>
      <td>
        <xsl:value-of select="@Name"/>
        <xsl:call-template name="SourceNote"/>
      </td>
      <td><xsl:call-template name="DxvaIds"/></td>
      <td><xsl:call-template name="LavCodecId"/></td>
    </tr>
  </xsl:template>
</xsl:stylesheet>

