require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    property = properties(:one)
    unit = units(:one)
    get property_unit_path(property, unit)
    assert_response :success
  end
end
