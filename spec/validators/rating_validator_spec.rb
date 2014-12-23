require 'spec_helper'
require 'youtube/data/rating_systems'
require 'youtube/exporter'
require 'youtube/validators/rating_validator'

describe Youtube::RatingValidator do
  let(:factory) { Metadata::Test::Factory.new(Youtube::Exporter) }
  let(:editorial_version) { factory.new_editorial_version }

  subject { Youtube::RatingValidator.new(editorial_version, :editorial_version) }

  describe '#validate' do
    it 'returns an error if rating system is invalid' do
      editorial_version.rating_system = 'urn:bogus'

      subject.validate.should == \
        "must be one of #{Youtube::RatingSystems::RATING_SYSTEM_CHOICES.to_sentence(:two_words_connector => ' or ', :last_word_connector => ', or ')}"
    end

    context 'using a location based rating system' do
      before do
        editorial_version.rating_system = Youtube::RatingSystems::YOUTUBE_RATING_SYSTEM
      end

      it 'returns nil if rating is valid' do
        editorial_version._rating_countries = %w(ES US)
        subject.validate.should be_nil
      end

      it 'returns and error if countries are invalid' do
        editorial_version._rating_countries = %w(XX XY)

        subject.validate.should == \
          'must be must be one of ISO 3166 alpha 2 country codes'
      end

      it 'returns nil for the whole world' do
        editorial_version._rating_countries = Youtube::Countries::WORLD

        subject.validate.should be_nil
      end
    end

    context 'when using an audience based rating system' do
      before do
        editorial_version.rating_system = Youtube::RatingSystems::MPAA_RATING_SYSTEM
      end

      it 'returns nil if rating if valid' do
        editorial_version.rating = Youtube::RatingSystems::MPAA_RATING_CHOICES.last

        subject.validate.should be_nil
      end

      it 'returns and error if rating is invalid' do
        editorial_version.rating = 'XX'

        subject.validate.should_not be_nil
      end
    end
  end
end
