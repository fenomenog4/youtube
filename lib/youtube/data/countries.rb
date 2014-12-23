module Youtube
  module Countries
    Dir.chdir(File.dirname(__FILE__)) do
      # ISO 3166 alpha 2 country codes. See http://en.wikipedia.org/wiki/ISO_3166-2#Current_codes
      COUNTRY_CHOICES = YAML.load(File.read('iso3166_alpha2.yml'))
    end

    WORLD = 'all'
  end
end
