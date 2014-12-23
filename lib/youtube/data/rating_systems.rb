module Youtube
  module RatingSystems
    # Youtube used rating systems.
    # See https://developers.google.com/youtube/2.0/reference#youtube_data_api_tag_media:rating
    RATING_SYSTEM_CHOICES = [
      MPAA_RATING_SYSTEM    = 'urn:mpaa',
      VCHIP_RATING_SYSTEM   = 'urn:v-chip',
      ACB_RATING_SYSTEM     = 'urn:acb',
      BBFC_RATING_SYSTEM    = 'urn:bbfc',
      CBFC_RATING_SYSTEM    = 'urn:cbfc',
      CHVRS_RATING_SYSTEM   = 'urn:chvrs',
      EIRIN_RATING_SYSTEM   = 'urn:eirin',
      FMOC_RATING_SYSTEM    = 'urn:fmoc',
      FSK_RATING_SYSTEM     = 'urn:fsk',
      ICAA_RATING_SYSTEM    = 'urn:icaa',
      KMRB_RATING_SYSTEM    = 'urn:kmrb',
      OFLC_RATING_SYSTEM    = 'urn:oflc',
      YOUTUBE_RATING_SYSTEM = 'http://gdata.youtube.com/schemas/2007#mediarating'
    ].freeze

    # For validating the rating from an editorial version
    # @internal
    #   Only for convenience. Note that we can generate this hash dinamically
    #   from the two above groups of constants but (by this time) I prefer to
    #   follow the zen of Python which state that
    #   'Explicit is better than implicit.'
    #
    RATING_SYSTEM_RATING_CHOICES = {
      MPAA_RATING_SYSTEM  => MPAA_RATING_CHOICES  = %w(g pg pg-13 r nc-17),
      VCHIP_RATING_SYSTEM => VCHIP_RATING_CHOICES = %w(v-y tv-y7 tv-y7-fv tv-g tv-pg tv-14 tv-ma),
      ACB_RATING_SYSTEM   => ACB_RATING_CHOICES   = %w(E G PG M MA15+ R18+),
      BBFC_RATING_SYSTEM  => BBFC_RATING_CHOICES  = %w(U PG 12 12 15 18 R18),
      CBFC_RATING_SYSTEM  => CBFC_RATING_CHOICES  = %w(U U/A A S),
      CHVRS_RATING_SYSTEM => CHVRS_RATING_CHOICES = %w(G PG 14A 18A R E),
      EIRIN_RATING_SYSTEM => EIRIN_RATING_CHOICES = %w(G PG-12 R15+ R18+),
      FMOC_RATING_SYSTEM  => FMOC_RATING_CHOICES  = %w(E U 10 12 16 18),
      FSK_RATING_SYSTEM   => FSK_RATING_CHOICES   = ['FSK 0', 'FSK 6', 'FSK 12', 'FSK 16', 'FSK 18'],
      ICAA_RATING_SYSTEM  => ICAA_RATING_CHOICES  = %w(E G PG M MA15+ R18+),
      KMRB_RATING_SYSTEM  => KMRB_RATING_CHOICES  = ['All', '12+', '15+', 'Teenager restricted', 'Restricted'],
      OFLC_RATING_SYSTEM  => OFLC_RATING_CHOICES  = %w(G PG R13 R15 R16 M R18)
    }.freeze
  end
end
