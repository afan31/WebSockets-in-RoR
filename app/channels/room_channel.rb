# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
require 'net/http'
require 'rubygems'
require 'json'
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  	#ActionCable.server.broadcast 'room_channel', message: data['message']
    # console.log(data);
    # var thingspeak = {};
    # thingspeak['url'] = 'https://api.thingspeak.com';
    # thingspeak['channel'] = 114928;
    # thingspeak['read_api_key'] = 'OMFKOZ3TO5Z03JGM';
    # thingspeak['write_api_key'] = '1T4IUM9PYYX0UBWF';
    # thingspeak['results'] = 5;
    # thingspeak['field_number'] = 1;

    # uri = URI('https://api.thingspeak.com/update?api_key=1T4IUM9PYYX0UBWF&field1=3')
    # uri = URI('https://api.thingspeak.com/channels/117945/fields/3.json?results=8004&api_key=OMFKOZ3TO5Z03JGM')
    # puts DateTime.now();
    # string text = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fffffff", CultureInfo.InvariantCulture)
    String endtime = DateTime.now.strftime().gsub("T", "%20")
    puts endtime
    #uri = URI('https://api.thingspeak.com/channels/117945/fields/3.json?&api_key=OMFKOZ3TO5Z03JGM&start=2016-06-01%2019:35:15&end=endtime')
    # uri = URI("https://api.thingspeak.com/channels/117945/fields/3.json?&api_key=OMFKOZ3TO5Z03JGM&end=#{endtime}")
    # #puts endtime.gsub("\"","")
    # puts "Value is #{endtime}"
    # uri = URI('https://www.youtube.com/watch?v=Xw6l4acJ3FIhttps://api.thingspeak.com/channels/117945/fields/3.json')
    # params = { :api_key => 'OMFKOZ3TO5Z03JGM', :end => endtime.to_i }
    # uri.query = URI.encode_www_form(params)
    #Net::HTTP.get(uri) # => String
    #puts Net::HTTP.get(uri)
    # res = Net::HTTP.get_response(uri)
    # puts res.body if res.is_a?(Net::HTTPSuccess)
    puts data['message'].to_i
    final_arr = []
    multiread(data['message'].to_i, endtime,final_arr)
  	#Message.create! content: data['message']
  end


  private
  def multiread(records, end_time,final_arr) 
    
    if (records < 8000)
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      puts end_time
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      #puts final_json
      uri = URI("https://api.thingspeak.com/channels/117945/fields/3.json?&api_key=OMFKOZ3TO5Z03JGM&end=#{end_time}&results=#{records}")
      res = Net::HTTP.get_response(uri)
      #puts res.body if res.is_a?(Net::HTTPSuccess)
      json_data = JSON.parse(res.body)
      final_arr.push(*json_data)
      #Message.create! content: data['res.body']
      ActionCable.server.broadcast 'room_channel', message: final_arr.reverse
    else
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      puts end_time
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"
      puts "------------------------------------------------------"

      uri = URI("https://api.thingspeak.com/channels/117945/fields/3.json?&api_key=OMFKOZ3TO5Z03JGM&end=#{end_time}")
      res = Net::HTTP.get_response(uri)
      #puts res.body if res.is_a?(Net::HTTPSuccess)
     
      json = JSON.parse(res.body)
      final_arr.push(*json)
      
      #final_json.concat(json);
      end_time =  json["feeds"][0]["created_at"]
      multiread(records-8000, end_time, final_arr)
    end
  end

end