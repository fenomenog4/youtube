require 'delegate'
require 'youtube/data/rating_systems'

module Youtube
  class EditorialVersion < SimpleDelegator
    def location_based_rating_system?
      rating_system == Youtube::RatingSystems::YOUTUBE_RATING_SYSTEM
    end

    def rating_countries
      self._rating_countries
    end
  end
end
