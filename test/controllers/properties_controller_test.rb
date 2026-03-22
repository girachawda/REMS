require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "TC-005 - View Property Inventory" do
    admin = users(:admin)
    post login_path, params: { email: admin.email, password: "password" }
    assert_response :redirect

    get properties_path
    assert_response :success

    assert_includes response.body, "Property Portfolio"
    assert_includes response.body, "Results (2)"

    assert_includes response.body, "Unit 101 - Test Plaza"
    assert_includes response.body, "Unit 201 - Second Property"

    assert_includes response.body, "1000.0 sq ft"
    assert_includes response.body, "1500.0 sq ft"
    assert_includes response.body, "$2000.0/month"
    assert_includes response.body, "$2500.0/month"

    assert_includes response.body, "Tier 1"
    assert_includes response.body, "Tier 2"
    assert_includes response.body, "Available"
    assert_includes response.body, "Occupied"

    assert_includes response.body, "123 Test St"
    assert_includes response.body, "456 Main Ave"
    assert_includes response.body, "Test property description"
    assert_includes response.body, "Another test property"
  end

  test "TC-007 - Search Submits Query" do
    get properties_path, params: { name: "Test" }
    assert_response :success
  end

  test "TC-008 - Results Page Lists Search Results" do
    get properties_path, params: { name: "Test" }
    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 101 - Test Plaza"
    assert_not_includes response.body, "Unit 201 - Second Property"
  end

  test "TC-009 - Search for Location with No Filter" do
    get properties_path
    assert_response :success
    assert_includes response.body, "Results (2)"
    assert_includes response.body, "Unit 101 - Test Plaza"
    assert_includes response.body, "Unit 201 - Second Property"
  end

  test "TC-010 - Search for Location with Filter" do
    get properties_path, params: { location: "Test" }
    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 101 - Test Plaza"
    assert_not_includes response.body, "Unit 201 - Second Property"

    get properties_path, params: { min_size: 1200 }
    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 201 - Second Property"
    assert_not_includes response.body, "Unit 101 - Test Plaza"

    get properties_path, params: { max_rate: 2200 }
    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 101 - Test Plaza"
    assert_not_includes response.body, "Unit 201 - Second Property"

    get properties_path, params: { classification: "tier_2" }
    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 201 - Second Property"
    assert_not_includes response.body, "Unit 101 - Test Plaza"

    get properties_path, params: { status: "available" }
    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 101 - Test Plaza"
    assert_not_includes response.body, "Unit 201 - Second Property"
  end

  test "TC-011 - Search for Location with Multiple Filters" do
    get properties_path, params: {
      classification: "tier_2",
      status: "occupied",
      min_size: 1200,
      max_rate: 2600
    }

    assert_response :success
    assert_includes response.body, "Results (1)"
    assert_includes response.body, "Unit 201 - Second Property"
    assert_not_includes response.body, "Unit 101 - Test Plaza"
  end

  test "TC-0049 - View Specific Location from Search" do
    property = properties(:one)
    get property_path(property)
    assert_response :success
    assert_includes response.body, "Test Plaza"
  end

  test "TC-0050 - Search - No Results" do
    get properties_path, params: { max_rate: 1 }
    assert_response :success
    assert_includes response.body, "Results (0)"
    assert_not_includes response.body, "Unit 101 - Test Plaza"
    assert_not_includes response.body, "Unit 201 - Second Property"
  end
end
