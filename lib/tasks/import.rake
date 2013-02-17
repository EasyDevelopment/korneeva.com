require 'nokogiri'
require 'open-uri'
require 'uri'

task :csv_disk_import do |task|  
end  	

desc "disk_import"

task :disk_import => :environment  do


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

  puts "import to db Disk -- #{id} "

  (id+1).times do |id| 
  	d = Disk.new(:id => id-1, :title => title[id-1], :body=> body[id-1], :year=> year[id-1],  :album_cover => album_cover[id-1]) 
	  puts "it's db Disk -- ##{d}"
    d.save
  end
  
    # id.times do |id| 
    #  	puts title[id]
    # 	puts body[id]
    # 	puts year[id]
    # 	puts album_cover[id]
    # end  	#	
end	



