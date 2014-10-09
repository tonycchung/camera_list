class CameraReader
  require 'amatch'
  include Amatch

  def initialize(file)
    @file = file
  end

  def deduplicate
    deduped = []
    File.foreach(@file) do |line|
      model = line.chomp
      deduped << model unless deduped.include?(model)
    end
    deduped.sort
  end

  def merge
    deduped_list = deduplicate
    list, map = [], {}
    m = JaroWinkler.new(simplify(deduped_list.first))
    list << deduped_list.first
    map[deduped_list.first] = list.last

    deduped_list.each do |model|
      simple = simplify(model)
      if m.match(simple) < 0.85
        m = JaroWinkler.new(simple)
        list << model
        map[model] = list.last
      else
        map[model] = list.last
      end
    end
    map
  end

  private

  def simplify(string)
    string.gsub(/\s+/, '').downcase
  end

end

# Running the script
reader = CameraReader.new('camera_list.txt')

# Remove duplicates in original camera_list file and output to file 'condensed_camera_list.txt'
output = File.open('deduplicated_camera_list.txt', 'w')
reader.deduplicate.each do |camera|
  output << "#{camera}\n"
end
output.close

# Raw map - giant hash
output = File.open('raw_map.txt', 'w')
output << reader.merge
output.close

# Pretty map - each key/value pair per line
output = File.open('pretty_map.txt', 'w')
reader.merge.each do |pair|
  output << "#{pair}\n"
end
output.close
