# !/usr/bin/crystal

foldn = 0
io = MemoryIO.new
File.each_line(ARGV[0]? || "ariafont.bdf") do |line|
  next unless line.starts_with? "ENCODING "

  character = line[/\d+/].to_i
  # Skip control characters
  next if character < 0x20

  io << " " << character.chr
  if foldn > 38
    io << "\n"
    foldn = 0
  else
    foldn += 1
  end
end

puts io rescue nil
