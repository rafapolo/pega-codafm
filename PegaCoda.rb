#!ruby19
# encoding: utf8
# author: rafael polo
# created_at 25.fev.2010

require 'open-uri'
require 'timeout'
require 'cgi'

class PegaCoda

  REGEX_ARTISTA = /<a href='\/artists\/([\d]+)'>\n<img/
  REGEX_ALBUM = /<a href='\/albums\/([\d]+)'>\n<img/
  
  def self.crawleia
  	23.times do |x| # a..z
	  x=x+1
	  page = load_url("http://coda.fm/artists?page=#{x}")
	  artistas = page.scan(REGEX_ARTISTA)
	  artistas.uniq.each do |artista_id|		
		pegaAlbuns(artista_id)
		puts
	  end
	end
  end
  
  def self.pegaAlbuns(artista_id)
	page = load_url("http://coda.fm/artists/#{artista_id}")
	if page
		artist = page.scan(/<h2>(.*)<\/h2>/)
		puts "Artista: #{artist}"
		albuns = page.scan(REGEX_ALBUM)
		albuns.uniq.each do |album_id|
			pegaAlbum(album_id)
		end
	end
  end
  
  def self.pegaAlbum(album_id)
	page = load_url("http://coda.fm/albums/#{album_id}")
	if page
		album = page.scan(/<h2 class='bottom'>(.*)<\/h2>/)
		href = page.scan(/class='link' href='(.*)' onClick/)
		puts "Album: #{album}"
		puts "Torrent: #{href}"
	end
  end
	 
  def self.load_url(url)
    response=""
    begin
      timeout(8) do
        uri = URI.parse(url)
        response = uri.read if uri
      end
    rescue Exception=>error
      response = false
      puts "Erro: #{error}\n\n"
    end
    response
  end
	
end

PegaCoda.crawleia



