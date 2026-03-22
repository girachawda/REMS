require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "TC-001 - Add New Location - Valid Inputs" do
    post property_units_path(properties(:one)), params: {
      unit: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: units(:one).classification,
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose
      }
    }
    assert_response :redirect
  end

  test "TC-002 - Add New Location - Blank Inputs" do
    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          size: units(:one).size,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: units(:one).size,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: units(:one).size,
          rental_rate: units(:one).rental_rate,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: units(:one).size,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: units(:one).size,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          status: units(:one).status
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "TC-003 - Add New Location - Incorrect Inputs" do
    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: -2,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: units(:one).size,
          rental_rate: -1,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: "",
          size: units(:one).size,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: units(:one).intended_business_purpose
        }
      }
    end
    assert_response :unprocessable_entity

    assert_no_difference("Unit.count") do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: units(:one).property_id,
          unit_number: units(:one).unit_number,
          size: units(:one).size,
          rental_rate: units(:one).rental_rate,
          classification: units(:one).classification,
          status: units(:one).status,
          intended_business_purpose: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

   test "TC-004 - Update Inventory Location" do
    patch property_unit_path(properties(:one), units(:one)), params: {
      unit: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: units(:one).classification,
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose
      }
    }
    assert_redirected_to properties_path
  end

  test "TC-006 - Add New Location - Classifications" do
    post property_units_path(properties(:one)), params: {
      unit: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: "tier_1",
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose
      }
    }
    assert_response :redirect

    post property_units_path(properties(:one)), params: {
      unit: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: "tier_2",
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose
      }
    }
    assert_response :redirect

    post property_units_path(properties(:one)), params: {
      unit: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: "tier_3",
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose
      }
    }
    assert_response :redirect

    post property_units_path(properties(:one)), params: {
      unit: {
        property_id: units(:one).property_id,
        unit_number: units(:one).unit_number,
        size: units(:one).size,
        rental_rate: units(:one).rental_rate,
        classification: "tier_4",
        status: units(:one).status,
        intended_business_purpose: units(:one).intended_business_purpose
      }
    }
    assert_response :redirect
  end

    test "TC-048 - View Specific Unit" do
    property = properties(:one)
    unit = units(:one)
    get property_unit_path(property, unit)
    assert_response :success
  end
end
