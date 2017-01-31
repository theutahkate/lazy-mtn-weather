class WeatherController < ApplicationController
  def index
  end

  def get_weather
    @weather_data_processor = Weather.new
    @weather_data_processor.write_csv(params[:start_date], params[:end_date])
    send_file(
      "#{Rails.root}/public/weather.csv",
      filename: "weather.csv",
      type: "text/csv"
    )
  end

end
