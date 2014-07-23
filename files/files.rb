require 'benchmark'
require './lib/enumerable'
require 'fileutils'


# Prepare variables
read_real_time = []
write_real_time = []
transfer_real_time = []


# File reading
100.times do
  s = ''
  fr  = File.new 'data/tweets.json', 'r'
  read_real_time.push Benchmark.realtime { s << fr.read }
  fr.close
end


# File writing
s = ''
fr  = File.new 'data/tweets.json', 'r'
s << fr.read
fr.close

100.times do
  fw  = File.new 'tmp/tweets.json', 'w'
  write_real_time.push Benchmark.realtime { fw << s }
  fw.close
end
s = ''


# File transferring
100.times do
  fr  = File.new 'data/tweets.json', 'r'
  ft  = File.new 'tmp/tweets.json', 'w'
  transfer_real_time.push Benchmark.realtime { ft << fr.read }
  fr.close
  ft.close
end


# Results
puts "read:     #{sprintf("%.4f", read_real_time.average)} +/- #{sprintf("%.4f", read_real_time.standard_deviation)}"
puts "write:    #{sprintf("%.4f", write_real_time.average)} +/- #{sprintf("%.4f", write_real_time.standard_deviation)}" 
puts "transfer: #{sprintf("%.4f", transfer_real_time.average)} +/- #{sprintf("%.4f", transfer_real_time.standard_deviation)}" 


# Remove all temp files
dir_path = './tmp/'
FileUtils.rm_rf("#{dir_path}/.", secure: true)