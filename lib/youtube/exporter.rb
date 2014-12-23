require 'youtube/editorial_version'
require 'youtube/validators'

module Youtube
  # Minimal metadata exporter for Youtube according Data API version 2. Note
  # that the Youtube Data API (v2) was officially deprecated on March 4, 2014.
  # See https://developers.google.com/youtube/terms#deprecation for more
  # information about Google's deprecation policy.
  class Exporter < Metadata::Exporter
    include ERB::Util

    MANIFEST = File.expand_path('../manifest.xml.erb', __FILE__)

    # Youtube assignable categories.
    # See https://developers.google.com/youtube/2.0/reference#YouTube_Category_List
    CATEGORY_CHOICES = %w(Film Autos Music Animals Sports Travel Games Videoblog People
                          Comedy Entertainment News Howto Education Tech Nonprofit)

    uses :exhibition_window do
      uses :title do
        uses :name, :present => true,
                    :max_length => 60,
                    :matches => /\A[^<>]*\z/,
                    :check => :name_length_under_100_bytes

        uses :long_description, :max_length => 5_000,
                                :matches    => /\A[^<>]*\z/

        # If no category is specified, YouTube will set the video's category
        # to the category of the last video that an user uploads. If no prior
        # upload exists, YouTube will set the video's category to People.
        uses :categories, :at_least => 1,
                          :at_most  => 1,
                          :in       => CATEGORY_CHOICES

        # Youtube will automatically set keywords to the video's filename if
        # not specified at all.
        uses :keywords, :at_least => 1,
                        :matches  => /\A[^<>]*\z/,
                        :present  => true,
                        :check    => :validate_keywords_bytesize
      end

      uses :editorial_version, :check => :validate_rating do
        uses :rating
        uses :rating_system
        # Identifies the country or countries where a video is considered
        # to contain restricted content. Only for
        # http://gdata.youtube.com/schemas/2007#mediarating rating system
        uses :_rating_countries
      end
    end

    def export(exhibition_window)
      title             = exhibition_window.title
      editorial_version = EditorialVersion.new(exhibition_window.editorial_version)

      beautify_xml template.result(binding)
    end

    alias_method :create, :export
    alias_method :update, :export

    def delete(_exhibition_window)
      nil
    end

    def name_length_under_100_bytes(name, md_attr)
      "#{md_attr} must be shorter than 100 bytes" if name.bytesize > 100
    end

    def validate_keywords_bytesize(keywords, md_attr)
      KeywordsBytesizeValidator.new(keywords, md_attr).validate
    end

    def validate_rating(rating, md_attr)
      RatingValidator.new(rating, md_attr).validate
    end

    private

    def template
      ERB.new(File.read(MANIFEST))
    end

    def beautify_xml(xml)
      Nokogiri::XML.parse(xml, nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS).to_xml
    end
  end
end
