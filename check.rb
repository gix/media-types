require 'nokogiri'

doc = open('MediaTypes.xml') { |f| Nokogiri::XML(f) }

l1 = doc.search('//VideoFormat[@FourCC]|//AudioFormat[@FourCC]|//PixelFormat[@FourCC]').map {|e| e['FourCC'][13..16] }
l2 = doc.search('//VideoFormatT[@FourCC]').map {|e| e['FourCC'][13..16] }
puts "Removable VideoFormatT:"
puts "  [%s]" % (l1 & l2).sort.join(', ')
puts

guids = {}
doc.search('//VideoFormat|//AudioFormat|//PixelFormat').each do |f|
  f.search('Guid').map { |e| e['Id'][0..38] }.uniq.each do |g|
    guids[g] ||= 0
    guids[g] += 1
  end
end
guids = guids.select { |id, count| count > 1 }.map { |id, count| id }
guids.delete_if { |id| id == '{????????-????-????-????-????????????}' }

puts "Duplicate GUIDs:"
puts "  [%s]" % guids.sort.join(', ')
puts

fccs = {}
doc.search('//VideoFormat|//AudioFormat|//PixelFormat').each do |f|
  next unless f['FourCC']
  fcc = f['FourCC'][0...10]
  fccs[fcc] = (fccs[fcc] || 0) + 1
end
fccs = fccs.select { |id, count| count > 1 }.map { |id, count| id }

puts "Duplicate FourCC:"
puts "  [%s]" % fccs.sort.join(', ')
puts

fccs = []
doc.search('//VideoFormat|//AudioFormat|//PixelFormat').each do |e|
  next unless e['FourCC']
  if e['FourCC'] !~ /^0x([A-Fa-f0-9]{8}) \((?:'(.{4})'|[A-Z0-9_]+)\)$/
    fccs << e['FourCC']
    next
  end

  num = $1
  str = $2
  if str && [num.to_i(16)].pack('I') != str
    fccs << e['FourCC']
  end
end

puts "Broken FourCC:"
puts "  [%s]" % fccs.sort.join(', ')
puts

wfs = {}
doc.search('//VideoFormat|//AudioFormat|//PixelFormat').each do |e|
  next unless e['WaveFormat']
  wf = e['WaveFormat'][0...6]
  wfs[wf] = (wfs[wf] || 0) + 1
end
wfs = wfs.select { |id, count| count > 1 }.map { |id, count| id }

puts "Duplicate WaveFormat:"
puts "  [%s]" % wfs.sort.join(', ')
puts
