require 'nokogiri'
require 'open-uri'
require 'uri'

desc "Import data from Disk db"

task :db_disk_import => :environment  do
  puts "Start parsing site!"

  id = 0
  url_main = "http://korneeva.com/disko.html"
  doc = Nokogiri::HTML(open(url_main), nil, 'UTF-8')  

  title = Array.new
  year = Array.new
  doc.css('h1').each do |node|
    if /20/ =~ node.text 
	    string = node.text
      year.push(string[-9..-2])
      title.push(string[0..-11])
    end
  end

  body = Array.new
  doc.css('div[class=disko]').each do |node|
    body.push(node.text.gsub(/\r\n/, "<br>")) 
    id += 1
  end

  album_cover = Array.new
  doc.css('div img').each do |node|
    if /jpg/ =~ node[:src] && ( (/4/ =~ node[:src]) != 8)
      album_cover.push("http://korneeva.com/" + node[:src].to_s)
    end 
  end

  puts "Import to db Disk"

  (id).times do |id| 
  	d = Disk.new(:id => id, :title => title[id], :body=> body[id], :year=> year[id],  :album_cover => album_cover[id]) 
    d.save
    puts "it's db Disk -- id database = #{d.id}"
  end
  
end
	



