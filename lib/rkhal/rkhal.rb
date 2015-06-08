require 'yaml'
require 'active_support/all'
require 'viewpoint'
include Viewpoint::EWS

module Rkhal
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


  def init
    begin
      $config = YAML.load_file(File.join(ENV['HOME'], '.rkhal.yaml'))
      $conn = Viewpoint::EWSClient.new $config['endpoint'], $config['username'], $config['password']
    rescue
      puts "Could not load config file".red
      puts "please make sure to create #{File.join(ENV['HOME'], '.rkhal.yaml')}"
      exit 1
    end
  end


  def get_week_str
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
  end

end

