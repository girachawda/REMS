require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    property = properties(:one)
    unit = units(:one)
    get property_unit_path(property, unit)
    assert_response :success
  end

  test "should get new" do
    get new_property_unit_path(properties(:one))
    assert_response :success
  end

  test "should get create" do
    post property_units_path(properties(:one)), params: {
      rental_application: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: units(:one).classification,
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose,
      }
    }
    assert_response :success
  end
end
