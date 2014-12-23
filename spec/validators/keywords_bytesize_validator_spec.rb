require 'spec_helper'
require 'youtube/validators/keywords_bytesize_validator'

describe Youtube::KeywordsBytesizeValidator do
  describe '#validate' do
    it 'returns nil if rating is valid' do
      keywords  = ['katana sword', 'ninjitsu', 'gymnastics']
      validator = Youtube::KeywordsBytesizeValidator.new(keywords, :keywords)

      validator.validate.should be_nil
    end

    it 'return and error if keywords length is longer than 500 bytes' do
      keywords  = ['katana sword', 'ninjitsu', 'gymnastics', 'X' * 500]
      validator = Youtube::KeywordsBytesizeValidator.new(keywords, :keywords)

      validator.validate.should == \
        'must be altogether at most 500 bytes long'
    end

    it 'return and error if individually keywords length are longer than 30 bytes' do
      keywords  = ['katana sword', 'ninjitsu', 'gymnastics', 'X' * 31]
      validator = Youtube::KeywordsBytesizeValidator.new(keywords, :keywords)

      validator.validate.should == \
        'must be individually at most 30 bytes long'
    end

    it 'return and error if individually keywords length are shorter than 2 bytes' do
      keywords  = ['katana sword', 'ninjitsu', 'gymnastics', 'X']
      validator = Youtube::KeywordsBytesizeValidator.new(keywords, :keywords)

      validator.validate.should == \
        'must be individually at least 2 bytes long'
    end
  end
end
