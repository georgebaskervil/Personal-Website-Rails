require "test_helper"

class EightyeightbythirtyoneControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get eightyeightbythirtyone_index_url
    assert_response :success
  end
end
