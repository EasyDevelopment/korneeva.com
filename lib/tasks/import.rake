require 'nokogiri'
require 'open-uri'
require 'uri'

task :csv_disk_import do |task|  
end  	


namespace :db do
  desc "disk_import"
  
  task :disk_import => :db  do


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

    id.times do |id| 
    	d = Disk.new #(:id => id, :title => title[id], :body=> body[id], :year=> year[id],  :album_cover => album_cover[id]) 
  	  d.id          = id
  	  d.title       = title[id]
  	  d.body        = body[id]
  	  d.year        = year[id]
  	  d.album_cover = album_cover[id]
  	  d.save
    end
  
    # id.times do |id| 
    #  	puts title[id]
    # 	puts body[id]
    # 	puts year[id]
    # 	puts album_cover[id]
    # end  	#	
  end	
end


