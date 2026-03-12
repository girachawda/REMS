require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get units_show_url
    assert_response :success
  end
end
