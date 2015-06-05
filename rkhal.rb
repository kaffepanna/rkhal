require 'yaml'
require 'active_support/all'
require 'viewpoint'
include Viewpoint::EWS

class String
def black;          "\033[30m#{self}\033[0m" end
def red;            "\033[31m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
def brown;          "\033[33m#{self}\033[0m" end
def blue;           "\033[34m#{self}\033[0m" end
def magenta;        "\033[35m#{self}\033[0m" end
def cyan;           "\033[36m#{self}\033[0m" end
def gray;           "\033[37m#{self}\033[0m" end
def bg_black;       "\033[40m#{self}\033[0m" end
def bg_red;         "\033[41m#{self}\033[0m" end
def bg_green;       "\033[42m#{self}\033[0m" end
def bg_brown;       "\033[43m#{self}\033[0m" end
def bg_blue;        "\033[44m#{self}\033[0m" end
def bg_magenta;     "\033[45m#{self}\033[0m" end
def bg_cyan;        "\033[46m#{self}\033[0m" end
def bg_gray;        "\033[47m#{self}\033[0m" end
def bold;           "\033[1m#{self}\033[22m" end
def reverse_color;  "\033[7m#{self}\033[27m" end
end


def get_body(item)
  body=""
  if item.body_type == "HTML"
    IO.popen('lynx -stdin -dump','r+') do |io|
      io.write item.body
      io.close_write
      body = io.read
    end
  end
  body.red
end


$config = YAML.load_file(File.join( File.dirname(File.expand_path(__FILE__)), 'rkhal.yaml'))

conn = Viewpoint::EWSClient.new $config['endpoint'], $config['username'], $config['password']

start_date = Date.today.at_beginning_of_week
end_date = Date.today.at_end_of_week

today = conn.find_items({:folder_id => :calendar,
                         :calendar_view => {
                           :start_date => start_date.to_datetime,
                           :end_date => end_date.to_datetime}})

day = ''
str =""

today.sort { |a,b| a.start <=> b.start }.each do |i|
  curr_day = i.start.to_date.strftime('%A')
  if curr_day != day
    str += "\n#{curr_day}\n".bold
    day = curr_day
  end
  
  str += "%s-%s %s %s\n" % [i.start.to_time.to_formatted_s(:time).green,
                            i.end.to_time.to_formatted_s(:time).green,
                            i.subject.gray,
                            (i.location || "") .cyan]
  #puts get_body(i)
end

puts str

