require 'erb'
require 'spec_helper'
require 'metadata/matchers'
require 'youtube/data/rating_systems'
require 'youtube/exporter'

describe Youtube::Exporter do
  let(:factory) { Metadata::Test::Factory.new(Youtube::Exporter) }

  describe '#export' do
    let(:editorial_version) do
      factory.new_editorial_version(
        :rating_system => Youtube::RatingSystems::MPAA_RATING_SYSTEM,
        :rating        => Youtube::RatingSystems::MPAA_RATING_CHOICES.last)
    end

    let(:long_description) { <<EO_DESC }
Johnathan Cabot is a champion gymnast. In the tiny, yet savage, country of Parmistan,
there is a perfect spot for a "star wars" site. For the US to get this site, they must
compete in the brutal "Game". The government calls on Cabot, the son of a former operative,
to win the game. Cabot must combine his gymnastics skills of the west with fighting secrets
of the east and form GYMKATA!
EO_DESC

    let(:title) do
      factory.new_title(
        :name             => 'Gymkata',
        :categories       => %w(Film),
        :keywords         => ['katana sword', 'ninjitsu', 'gymnastics'],
        :long_description => long_description)
    end

    let(:exhibition_window) do
      factory.new_exhibition_window(
        :title             => title,
        :editorial_version => editorial_version)
    end

    context 'when using a location based rating system' do
      let(:editorial_version) do
        factory.new_editorial_version(
          :rating_system     => Youtube::RatingSystems::YOUTUBE_RATING_SYSTEM,
          :rating            => 1,
          :_rating_countries => %w(ES US))
      end

      it 'generates valid XML' do
        subject.export(exhibition_window).should be_congruent_to(<<EO_XML)
<?xml version="1.0"?>

<entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007">
  <media:group>
    <media:title type="plain">Gymkata</media:title>
    <media:description type="plain">#{ERB::Util.h(long_description)}</media:description>
    <media:category label="Film" scheme="http://gdata.youtube.com/schemas/2007/categories.cat">
      Film
    </media:category>
    <media:keywords>katana sword,ninjitsu,gymnastics</media:keywords>
    <media:rating scheme="http://gdata.youtube.com/schemas/2007#mediarating" country="ES,US">
      1
    </media:rating>
  </media:group>
</entry>
EO_XML
      end
    end

    it 'generates valid XML' do
      subject.export(exhibition_window).should be_congruent_to(<<EO_XML)
<?xml version="1.0"?>

<entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007">
  <media:group>
    <media:title type="plain">Gymkata</media:title>
    <media:description type="plain">#{ERB::Util.h(long_description)}</media:description>
    <media:category label="Film" scheme="http://gdata.youtube.com/schemas/2007/categories.cat">
      Film
    </media:category>
    <media:keywords>katana sword,ninjitsu,gymnastics</media:keywords>
    <media:rating scheme="urn:mpaa">nc-17</media:rating>
  </media:group>
</entry>
EO_XML
    end
  end

  describe '#delete' do
    it 'returns a null payload' do
      Youtube::Exporter.new.delete(:exhibition_window).should be_nil
    end
  end

  describe '#name_length_under_100_bytes' do
    it 'returns nil if name length is shorter than 100' do
      name = 'Gymkata'
      subject.name_length_under_100_bytes(name, 'name').should be_nil
    end

    it 'returns an error if the name length is greater than 100 bytes' do
      name = 'á' * 51
      subject.name_length_under_100_bytes(name, 'name').should == \
        'name must be shorter than 100 bytes'
    end
  end
end
