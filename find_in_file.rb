require_relative './init.rb'
require_relative './matcher.rb'


module Haystack
  class FindInFile
    attr_reader :origin_path, :matcher_klass, :terms_uri

    def initialize(origin_path: "", matcher_klass: Haystack::Matcher, terms_uri: "http://hub-client.lib.umn.edu/lookups/13.json")
      @origin_path   = origin_path
      @matcher_klass = matcher_klass
      @terms_uri     = URI(terms_uri)
    end

    def each_found(&persister)
      File.foreach("#{origin_path}") do |file|
        file.each_line do |line|
          matcher = matcher_klass.new(record: parse(line), terms: terms)
          if matcher.matched?
            persister.call(Oj.dump(matcher.record_with_match))
          end
        end
      end
    end

    def terms
      @term_data ||= Oj.load(Net::HTTP.get_response(terms_uri).body)['pattern'].join('|')
    end

    def parse(record_string)
      json = format_line(record_string)
      (json != '') ? Oj.load(json)['_source'] : {}
    end

    def format_line(data)
      data.gsub!(/(,)$/, '')
      data.gsub!(/^(,)/, '')
      data.gsub!(/^\[/, '')
      data.gsub!(/^\]/, '')
      data.strip
    end
  end
end