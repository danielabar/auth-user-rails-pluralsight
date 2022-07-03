module HomeHelper
  def articles(query)
    require 'rss'
    require 'open-uri'
    # instructor's US feed
    # url = "https://news.google.com/rss/search?cf=all*h1=en-US&pz=1&q=#{query}&gl=US&ceid=US:en"
    # my Canadian feed
    url = "https://news.google.com/rss/search?q=#{query}&hl=en-CA&gl=CA&ceid=CA%3Aen"
    open(url) do |rss|
      RSS::Parser.parse(rss)
    end
  end
end
