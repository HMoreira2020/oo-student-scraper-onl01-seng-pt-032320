require 'net/http'
require 'nokogiri' 
require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :name, :location, :profile_url 
  

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    students_index_array = []
  
    html.css(".student-card").collect do |student| 
      student_hash = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students_index_array << student_hash 
    end
    students_index_array
  end


  def self.scrape_profile_page(profile_url)
    profile_html = Nokogiri::HTML(open(profile_url))
    student_profile_hash = {} 
    profile_html.css("div.social-icon-container a").collect do |icon| 
      url = icon.attribute("href").value 
      student_profile_hash[:twitter] = url if url.include?("twitter") 
      student_profile_hash[:linkedin] = url if url.include?("linkedin") 
      student_profile_hash[:github] = url if url.include?("github") 
      student_profile_hash[:blog] = url if icon.css("img").attribute("src").text.include?("rss") 
    end
    student_profile_hash[:profile_quote] = profile_html.css("div.profile-quote").text 
    student_profile_hash[:bio] = profile_html.css("div.description-holder p").text 
    student_profile_hash 

  end

end

