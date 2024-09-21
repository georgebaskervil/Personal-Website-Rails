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
    # Generate a random number from 100000 to 999999 to ensure it's always six digits
    raw_number = rand(100000...1000000)
    
    formatted_number = raw_number.to_s
    
    @random_number = formatted_number.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

end