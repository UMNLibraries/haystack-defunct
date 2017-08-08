require 'json'

class DPLASplitter
  attr_reader :destination_dir

  def split!(origin_filepath, destination_dir)
    @destination_dir = destination_dir
    f = File.open(origin_filepath, "r")
    batch = []
    keys  = []
    count = 0
    f.each_line do |line|
      batch << line if valid_json?(line)
      if batch.length == 501
        keys << save_batch(batch, count)
        count = count + batch.length
        batch = []
      end
    end
    save_keys(keys)
    f.close
  end

  def save_keys(keys)
    File.open("#{destination_dir}/keys.json", 'w') { |file| file.write(JSON.generate(keys)) }
  end

  def save_batch(batch, delta)
    name = "batch-#{delta}.json"
    File.open("#{destination_dir}/#{name}", 'w') { |file| file.write(batch_to_json(batch)) }
    name
  end

  def batch_to_json(batch)
    "[#{batch.join(',')}]"
  end

def valid_json?(json)
  begin
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end
end

splitter = DPLASplitter.new
splitter.split!('matches.json', 'batches')