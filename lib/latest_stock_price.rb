module LatestStockPrice
  require 'net/http'
  require 'json'

  BASE_URL = 'https://latest-stock-price.p.rapidapi.com'

  def self.price_all
    fetch_data('/any')
  end

  def self.equities(isin = nil, only_index = nil, indices = nil)
    fetch_data("/equities?Search=#{search}&OnlyIndex=#{only_index}&Indices=#{indices}")
  end

  def self.equities_search(search = nil)
    fetch_data("/equities-search?Search=#{search}")
  end
  
  def self.equities_enhanced(symbol = nil)
    fetch_data("/equities-enhanced?Symbols=#{symbol}")
  end

  private

  def self.fetch_data(endpoint)
    uri = URI("#{BASE_URL}#{endpoint}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["x-rapidapi-key"] = 'a9639d85abmsh3a8d4083e6fec75p1b7a77jsnb1460995cda9'
    request["x-rapidapi-host"] = 'latest-stock-price.p.rapidapi.com'

    begin
      response = http.request(request)
      JSON.parse(response.body)
    rescue JSON::ParserError, TypeError => e
      puts e
    end
  end
end
