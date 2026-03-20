require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end
  
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

  test "TC-001 - Add New Location - Valid Inputs" do
    post property_units_path(properties(:one)), params: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: units(:one).classification,
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose,
    }
    assert_response :success
  end

  test "TC-002 - Add New Location - Blank Inputs" do
    post property_units_path(properties(:one)), params: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        rental_rate: units(:one).rental_rate,
        classification: units(:one).classification,
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose,
    }
    assert_response :unprocessable_entity
  end

  test "TC-003 - Add New Location - Incorrect Inputs" do
    post property_units_path(properties(:one)), params: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: -2,
        rental_rate: units(:one).rental_rate,
        classification: units(:one).classification,
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose,
    }
    assert_response :unprocessable_entity
  end
end
