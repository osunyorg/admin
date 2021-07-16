require "test_helper"

class Qualiopi::IndicatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qualiopi_indicator = qualiopi_indicators(:one)
  end

  test "should get index" do
    get qualiopi_indicators_url
    assert_response :success
  end

  test "should get new" do
    get new_qualiopi_indicator_url
    assert_response :success
  end

  test "should create qualiopi_indicator" do
    assert_difference('Qualiopi::Indicator.count') do
      post qualiopi_indicators_url, params: { qualiopi_indicator: { criterion_id: @qualiopi_indicator.criterion_id, level_expected: @qualiopi_indicator.level_expected, name: @qualiopi_indicator.name, non_conformity: @qualiopi_indicator.non_conformity, number: @qualiopi_indicator.number, proof: @qualiopi_indicator.proof, requirement: @qualiopi_indicator.requirement } }
    end

    assert_redirected_to qualiopi_indicator_url(Qualiopi::Indicator.last)
  end

  test "should show qualiopi_indicator" do
    get qualiopi_indicator_url(@qualiopi_indicator)
    assert_response :success
  end

  test "should get edit" do
    get edit_qualiopi_indicator_url(@qualiopi_indicator)
    assert_response :success
  end

  test "should update qualiopi_indicator" do
    patch qualiopi_indicator_url(@qualiopi_indicator), params: { qualiopi_indicator: { criterion_id: @qualiopi_indicator.criterion_id, level_expected: @qualiopi_indicator.level_expected, name: @qualiopi_indicator.name, non_conformity: @qualiopi_indicator.non_conformity, number: @qualiopi_indicator.number, proof: @qualiopi_indicator.proof, requirement: @qualiopi_indicator.requirement } }
    assert_redirected_to qualiopi_indicator_url(@qualiopi_indicator)
  end

  test "should destroy qualiopi_indicator" do
    assert_difference('Qualiopi::Indicator.count', -1) do
      delete qualiopi_indicator_url(@qualiopi_indicator)
    end

    assert_redirected_to qualiopi_indicators_url
  end
end
