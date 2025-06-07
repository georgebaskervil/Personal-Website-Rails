class Api::V1::StatsController < ApplicationController
  # Skip CSRF for API endpoints
  skip_before_action :verify_authenticity_token
  
  def request_count
    render json: { 
      count: RequestCounterMiddleware.current_count,
      timestamp: Time.current.iso8601
    }
  end
  
  def time_since
    site_start_date = Time.new(2019, 5, 7)
    duration = Time.now - site_start_date
    years = (duration / (86_400 * 365)).to_i
    remaining_days = duration % (86_400 * 365)
    months = (remaining_days / (86_400 * 30)).to_i
    days = ((remaining_days % (86_400 * 30)) / 86_400).to_i
    
    render json: {
      years: years,
      months: months,
      days: days,
      timestamp: Time.current.iso8601
    }
  end
  
  def current_day
    render json: {
      day: Date.today.strftime("%A"),
      timestamp: Time.current.iso8601
    }
  end
end
