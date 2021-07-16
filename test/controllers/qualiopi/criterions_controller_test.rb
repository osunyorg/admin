require "test_helper"

class Qualiopi::CriterionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qualiopi_criterion = qualiopi_criterions(:one)
  end

  test "should get index" do
    get qualiopi_criterions_url
    assert_response :success
  end

  test "should get new" do
    get new_qualiopi_criterion_url
    assert_response :success
  end

  test "should create qualiopi_criterion" do
    assert_difference('Qualiopi::Criterion.count') do
      post qualiopi_criterions_url, params: { qualiopi_criterion: { description: @qualiopi_criterion.description, name: @qualiopi_criterion.name, number: @qualiopi_criterion.number } }
    end

    assert_redirected_to qualiopi_criterion_url(Qualiopi::Criterion.last)
  end

  test "should show qualiopi_criterion" do
    get qualiopi_criterion_url(@qualiopi_criterion)
    assert_response :success
  end

  test "should get edit" do
    get edit_qualiopi_criterion_url(@qualiopi_criterion)
    assert_response :success
  end

  test "should update qualiopi_criterion" do
    patch qualiopi_criterion_url(@qualiopi_criterion), params: { qualiopi_criterion: { description: @qualiopi_criterion.description, name: @qualiopi_criterion.name, number: @qualiopi_criterion.number } }
    assert_redirected_to qualiopi_criterion_url(@qualiopi_criterion)
  end

  test "should destroy qualiopi_criterion" do
    assert_difference('Qualiopi::Criterion.count', -1) do
      delete qualiopi_criterion_url(@qualiopi_criterion)
    end

    assert_redirected_to qualiopi_criterions_url
  end
end
