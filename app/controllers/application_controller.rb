# In app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # Increment the number of HTTP requests that have been made
  before_action :increment_HTTP_req_counter

  # Generate a random number
  before_action :set_random_number

  private

  def increment_HTTP_req_counter
    HttpReqCounter.first_or_create.increment!(:count)
  end

  def set_random_number
    # Generate a random number from 0 to 999,999
    raw_number = rand(1_000_000)
    
    # Format the number with commas
    @random_number = raw_number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

end