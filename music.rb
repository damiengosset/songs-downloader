#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
song = ARGV[0]
song = song.downcase.tr(" ", "+")
doc = Nokogiri::HTML(open("https://www.youtube.com/results?search_query=#{song}"))
url = doc.css("h3.yt-lockup-title a").first['href']
song_url = "http://www.youtube.com#{url}"

# puts song_url

doc = Nokogiri::HTML(open("http://www.last.fm/search?q=#{song}&type=track"))
url = doc.css("td.track a").first['href']
puts doc.css("td.track a").first.content#get title of youtube track
# puts url

chop = url.gsub('/music/', "")
# puts chop
artist, title = chop.split("/_/")
artist = artist.gsub('+', " ")
title = title.gsub('+', " ")
#http://www.last.fm/search?q=bonobo+kiara&type=track

doc = Nokogiri::HTML(open("http://www.last.fm#{url}"))
album = doc.css("h3 a").first
art_link = doc.css("section.media a").first['href']
puts art_link
puts album.content
puts artist
puts title

doc = Nokogiri::HTML(open("http://www.last.fm#{art_link}"))
art = doc.css("div.g img").first['src']

temp_file = (0...16).map { (65 + rand(26)).chr }.join
response = %x( youtube-dl #{song_url} -o "/Users/ryanhelsing/Music/iTunes/iTunes\ Media/Automatically\ Add\ to\ iTunes.localized/#{temp_file}.%(ext)s" -x --audio-format "mp3" --prefer-ffmpeg )

puts response

require "mp3info"

require "open-uri"
require 'open-uri'
open('image.png', 'wb') do |file|
  file << open('http://userserve-ak.last.fm/serve/126s/86192233.png').read
end

Mp3Info.open("/Users/ryanhelsing/Music/iTunes/iTunes\ Media/Automatically\ Add\ to\ iTunes.localized/#{temp_file}.mp3") do |mp3|
  mp3.tag.title = "#{title}"
  mp3.tag.artist = "#{artist}"
  mp3.tag.album = "#{album.content}"
  open('image.png', 'wb') do |file|
  	mp3.tag2.add_picture(open(art).read)
  end
end

# rename file
new_name = "/Users/ryanhelsing/Music/iTunes/iTunes\ Media/Automatically\ Add\ to\ iTunes.localized/#{artist} - #{title}.mp3"
File.rename("/Users/ryanhelsing/Music/iTunes/iTunes\ Media/Automatically\ Add\ to\ iTunes.localized/#{temp_file}.mp3", new_name)
# response = %x( mv #{new_name} ~/Music/iTunes/iTunes\ Media/Automatically\ Add\ to\ iTunes.localized/)
# puts response

# import into itunes

# delete file