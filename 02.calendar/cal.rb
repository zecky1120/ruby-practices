require 'optparse'
require 'date'

year = Date.today.year
month = Date.today.month
option = {y: year, m: month}
opt = OptionParser.new
opt.on('-y VAL', Integer, '年を入力しください（数字のみ）') {|v| option[:y] = v }
opt.on('-m VAL', Integer, '月を入力しください（数字のみ）') {|v| option[:m] = v }
opt.parse(ARGV)
start_day = Date.new(option[:y], option[:m], 1)
last_day = Date.new(option[:y], option[:m], -1)

puts "#{option[:m]}月 #{option[:y]}".center(20)
puts '日 月 火 水 木 金 土'.center(16)

week_number = start_day.wday
space = '   ' * week_number
print space

(start_day..last_day).each do |day|
  print day.mday.to_s.rjust(3)
  if day.saturday?
    print "\n"
  end
end
print "\n"
