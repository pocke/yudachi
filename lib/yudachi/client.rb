require 'cgi'
require 'open-uri'
require 'json'

module Yudachi
  class Client
    def initialize(app_id:)
      @app_id = app_id
    end

    def location_name_and_coodinated_geometry(query)
      url = "https://map.yahooapis.jp/geocode/V1/geoCoder?appid=#{@app_id}&output=json&query=#{CGI.escape(query)}"
      response = get url
      feature = response["Feature"]&.first
      [feature&.dig('Name'), feature&.dig('Geometry', 'Coordinates')]
    end

    def rainfall(geometry)
      url = "https://map.yahooapis.jp/weather/V1/place?appid=#{@app_id}&output=json&coordinates=#{geometry}&past=1&interval=5"
      response = get url
      features = response["Feature"]

      features&.first&.dig("Property", "WeatherList", "Weather").each do |data|
        data['Date'] = Time.parse(data['Date'])
      end
    end

    private def get(url)
      JSON.parse(URI.open(url).read)
    end
  end
end
