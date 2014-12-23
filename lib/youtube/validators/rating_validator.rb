require 'active_support'
require 'yaml'
require 'youtube/data/countries'
require 'youtube/data/rating_systems'

module Youtube
  class RatingValidator
    include Youtube::RatingSystems
    include Youtube::Countries

    def initialize(editorial_version, md_attr)
      @editorial_version = editorial_version
      @rating_system     = editorial_version.rating_system
      @rating            = editorial_version.rating
      @rating_countries  = editorial_version._rating_countries
      @md_attr           = md_attr
    end

    def validate
      message = check_rating_system_in_choices

      if message.blank?
        if @editorial_version.rating_system == YOUTUBE_RATING_SYSTEM
          message = check_countries_in_choices if @rating_countries != WORLD
        else
          message = check_rating_in_system_choices
        end
      else
        message
      end
    end

    private

    def check_rating_system_in_choices
      return if RATING_SYSTEM_CHOICES.include?(@rating_system)

      "must be one of #{RATING_SYSTEM_CHOICES.to_sentence(:two_words_connector => ' or ', :last_word_connector => ', or ')}"
    end

    def check_rating_in_system_choices
      rating_system_choices = RATING_SYSTEM_RATING_CHOICES.fetch(@rating_system, {})

      return if rating_system_choices.include?(@rating)

      rating_label = @editorial_version.md_attrs(:rating)
      "must be one of #{rating_system_choices.to_sentence(:two_words_connector => ' or ', :last_word_connector => ', or ')}"
    end

    def check_countries_in_choices
      "must be must be one of ISO 3166 alpha 2 country codes" if @rating_countries.any? { |country| COUNTRY_CHOICES.exclude? country }
    end
  end
end
