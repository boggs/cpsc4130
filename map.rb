require 'pry'
require 'yaml'

sentiment_lexicon = YAML::load(File.open('sentiment_lexicon.yml'))

ARGF.each do |line|
  begin
    # Skip if no actual text to work on
    next if line.length <= 0

    # clean up hanging spaces and stuff
    line.chomp!
    word_array = line.split(' ')

    sentiment = word_array.inject(0) do |sent, word|
      word = word.to_sym
      sent += sentiment_lexicon.fetch(word, 0)
      sent
    end

    puts sentiment
  rescue
  end
end
