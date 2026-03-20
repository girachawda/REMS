require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  test "TC005 - View Property Inventory" do
    get properties_path
    assert_response :success
  end

  test "should get show" do
    property = properties(:one)
    get property_path(property)
    assert_response :success
  end
end
