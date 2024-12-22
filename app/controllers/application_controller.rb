class ApplicationController < ActionController::Base
  before_action :increment_HTTP_req_counter

  private

  def increment_HTTP_req_counter
    HttpReqCounter.first_or_create.increment!(:count)
  end
end
