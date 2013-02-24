#encoding: utf-8
require 'mechanize'
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
	
task :db_songs_import => :environment do

  a = Mechanize.new
  p = a.get('http://korneeva.com/repert.html')
  table = p.parser.xpath "/html/body/table/tr[count(td)=4]"

  table.each do |r|
    row = r.xpath "td"

    download_url = nil
    record_year = nil

    if row[1].xpath("a").any?
      download_url = "http://korneeva.com" + row[1].xpath("a")[0]['href']
      record_year = (/(\d\d\d\d)/.match(row[1].xpath("a")[0].children[0].text))[1]
    end

    name = (row[2].xpath("*/a")[0]).text
    text_url = row[2].xpath("*/a")[0]['href']
    author = row[3].text

    text_page = a.get(text_url)
    text_node = text_page.parser.xpath("//pre/b")[0]

    if text_node.nil?
      text_node = text_page.parser.xpath("//pre/i/i/b")[0]
    end

    text = text_node.text

    song = Song.new

    song.authors = author
    song.title  = name
    song.lyrics = text.gsub(/\r\n/, "<br>")

    song.record_year = record_year
    song.record = download_url

    song.save

    text_page.links_with(:text => %r{Лист.*}i).each do |lnk|
      note_page = a.get("http://korneeva.com" + ( lnk.href.sub /.*\'(.*)\'.*/, '\1' ))


      note = song.notes.new
      note.link = (note_page.parser.xpath("//img")[0]['src']).gsub(/\.\./, "http://korneeva.com")

      note.save
    end

  end
end

task :db_guestbook_import => :environment do

end