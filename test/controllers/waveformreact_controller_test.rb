require "test_helper"

class WaveformreactControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get waveformreact_index_url
    assert_response :success
  end
end
