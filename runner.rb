require_relative './init.rb'
require_relative './find_in_file.rb'

module Haystack
  class Runner
    def run!
      finder.each_found do |record|
        File.open('../matched_records.json', 'a') { |f| f.write(",#{record}") }
      end
    end

    def finder
      @finder ||= Haystack::FindInFile.new(origin_path: "../chunks/#{OPTIONS[:chunk]}", terms_uri: OPTIONS[:terms_uri])
    end
  end
end

Haystack::Runner.new.run!