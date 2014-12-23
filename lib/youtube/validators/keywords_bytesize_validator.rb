module Youtube
  class KeywordsBytesizeValidator
    def initialize(keywords, md_attr)
      @keywords = keywords.map { |keyword| normalize_as_youtube_does(keyword) }
      @md_attr  = md_attr
    end

    def validate
      check_keywords_length_under_500_bytes or
        check_each_keyword_length_over_2_bytes or
        check_each_keyword_length_under_30_bytes
    end

    private

    def check_keywords_length_under_500_bytes
      return unless keywords_bytesize > 500
      "must be altogether at most 500 bytes long"
    end

    def check_each_keyword_length_over_2_bytes
      return unless @keywords.any? { |keyword| keyword.bytesize < 2 }
      "must be individually at least 2 bytes long"
    end

    def check_each_keyword_length_under_30_bytes
      return unless @keywords.any? { |keyword| keyword.bytesize > 30 }
      "must be individually at most 30 bytes long"
    end

    def keywords_bytesize
      @keywords.join(',').bytesize
    end

    # Youtube's API server infers that there are quotation marks around the
    # keyword if it contains spaces
    def normalize_as_youtube_does(keyword)
      return keyword unless keyword.include?(' ')
      "\"#{keyword}\""
    end
  end
end
