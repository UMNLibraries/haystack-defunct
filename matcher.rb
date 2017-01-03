module Haystack
  class Matcher
    attr_reader :terms, :record

    def initialize(record: {}, terms: '')
      @record = record
      @terms  = terms
    end

    def matched?
      (value =~ /#{terms}/i) != nil
    end

    def record_with_match
      record.merge('matches_ssi' => matches)
    end

    def matches
      value.gsub(/(#{terms})/i, "<strong>\\1</strong>")
    end

    private

    def value
      @value ||= field_values
    end

    def field_values
      data = []
      data << record.fetch('originalRecord', {}).fetch('header', {}).fetch('setSpec', '')
      sourceResource = record.fetch('sourceResource', {})
      data << record.fetch('title', '')
      data << sourceResource.fetch('title', '')
      data << collection_values(sourceResource)
      data << sourceResource.fetch('subject', []).map { |subject| subject['name'] }
      data << sourceResource.fetch('creator', '')
      data << sourceResource.fetch('contributor', '')
      data << sourceResource.fetch('description', '')
      data.flatten.compact.map { |term| term.to_s.downcase.strip }.join(' ').strip
    rescue => e
        err = "Error For record: #{record['id']} \n\n --------------------- \n\n #{Oj.dump(record)} \n\n --------------------- \n\n #{e}"
        File.open('./errors.log', 'a') { |file| file.write("#{err} \n\n") }
    end

    def collection_values(sourceResource)
      collections = sourceResource.fetch('collection', {})
      if collections.is_a?(Hash)
        "#{collections.fetch('title', '')} #{collections.fetch('description', '')}"
      elsif collections.is_a?(Array)
        collections.map { |collection| " #{collection.fetch('title', '')} #{collection.fetch('description', '')} " }.join(' ')
      end
    end

  end
end