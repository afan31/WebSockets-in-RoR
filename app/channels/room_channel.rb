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

    puts data['message']
    if data['message'].include? "write"
      data['message'].slice! "write"
      puts data['message'].to_i
      uri = URI("https://api.thingspeak.com/update?api_key=1T4IUM9PYYX0UBWF&field3=" + data['message'])
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        ActionCable.server.broadcast 'room_channel', message: "Data Inserted into the channel"
      end
    else
      String endtime = DateTime.now.strftime().gsub("T", "%20")
      puts endtime
      puts data['message'].to_i
      final_arr = []
      multiread(data['message'].to_i, endtime,final_arr)
    end
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