# !/usr/bin/crystal

require "json"

font = File.read_lines(ARGV[0]? || "ariafont.bdf")
unicode = JSON.parse(File.read("UnicodeData.json"))

io = MemoryIO.new

font.each_with_index do |line, index|
  unless line.starts_with? "STARTCHAR "
    io << line
    next
  end

  # Get ENCODING field
  charcode = font[index + 1][/\d+/]

  begin
    # Get the character name.
    charname = unicode[charcode][0]
  rescue KeyError
    # Skip if the character code isn't in the data.
    io << line
    next
  end

  # Skip if it belongs to a range, like the private area.
  if charname =~ "<.*>"
    io << line
    next
  end

  io << line.sub(/STARTCHAR (.+)/, "STARTCHAR #{charname}")
end

print io
