require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get properties_path
    assert_response :success
  end

  test "should get show" do
    property = properties(:one)
    get property_path(property)
    assert_response :success
  end
end
