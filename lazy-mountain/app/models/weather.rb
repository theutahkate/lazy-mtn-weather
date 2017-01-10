class Weather
  include Categories
  require 'net/http'
  require 'csv'
  require 'json'

  def write_csv
    File.write('weather.csv', csv)
  end

  private

  # def build_uri_array start_date, end_date
  def build_uri_array
    uri_array = []
    Date.new(2016, 01, 01).upto(Date.new(2016, 01, 03)) do |date|
    # make sure dates are in the right format going in, then replace line 15 with 17, and the stuff in get_weather_data
    # Date.new(start_date).upto(Date.new(end_date)) do |date|
      uri_date = date.strftime('%Y%m%d')
      uri = URI("http://api.wunderground.com/api/c99449ee72a791c6/history_#{uri_date}/q/AK/Lazy_Mountain.json")
      uri_array << uri
    end
    uri_array
  end

  # def get_weather_data start, ending
  def get_weather_data
    year_array = []
    # build_uri_array(start, ending)
    uri_array = build_uri_array
    uri_array.each do |uri|
      data = Net::HTTP.get(uri)
      output = JSON.parse(data)
      observations = output["history"]["observations"]
      year_array << observations
    end
    year_array.flatten
  end


  def sanitize h
    h["utcdate"] = h["utcdate"]["pretty"]
    READABLE_HEADINGS.keys.each do |k|
      if h[k].include? "-9999.0"
        h[k] = "0"
      end
    end
  end

  def csv
    year_array = get_weather_data
    CSV.generate do |csv|
      csv << READABLE_HEADINGS.values
      year_array.each do |h|
        sanitize(h)
        csv << h.values_at(*READABLE_HEADINGS.keys)
      end
    end
  end

end
