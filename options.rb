require 'optparse'

OPTIONS = {}
OptionParser.new do |opts|
  opts.banner = "Usage: haystack.rb [options]"

  opts.on("-t", "--terms_uri TERMS_URI", "URI for term matchers (e.g. http://hub-client.lib.umn.edu/lookups/13.json") do |terms_uri|
    OPTIONS[:terms_uri] = terms_uri
  end

  opts.on("-c", "--chunk CHUNK", "Require the chunk to load before executing your script") do |chunk|
    OPTIONS[:chunk] = chunk
  end
end.parse!