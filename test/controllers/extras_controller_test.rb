require "test_helper"

class ExtrasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get extras_index_url
    assert_response :success
  end
end
