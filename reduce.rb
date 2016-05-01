total = 0
ARGF.each do |line|
  line = line.chomp
  line = line.to_f

  total += line
end
