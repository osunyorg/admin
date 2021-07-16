require "test_helper"

class ProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @program = programs(:one)
  end

  test "should get index" do
    get programs_url
    assert_response :success
  end

  test "should get new" do
    get new_program_url
    assert_response :success
  end

  test "should create program" do
    assert_difference('Program.count') do
      post programs_url, params: { program: { accessibility: @program.accessibility, capacity: @program.capacity, continuing: @program.continuing, duration: @program.duration, ects: @program.ects, evaluation: @program.evaluation, level: @program.level, name: @program.name, objectives: @program.objectives, pedagogy: @program.pedagogy, prerequisites: @program.prerequisites, registration: @program.registration, university_id: @program.university_id } }
    end

    assert_redirected_to program_url(Program.last)
  end

  test "should show program" do
    get program_url(@program)
    assert_response :success
  end

  test "should get edit" do
    get edit_program_url(@program)
    assert_response :success
  end

  test "should update program" do
    patch program_url(@program), params: { program: { accessibility: @program.accessibility, capacity: @program.capacity, continuing: @program.continuing, duration: @program.duration, ects: @program.ects, evaluation: @program.evaluation, level: @program.level, name: @program.name, objectives: @program.objectives, pedagogy: @program.pedagogy, prerequisites: @program.prerequisites, registration: @program.registration, university_id: @program.university_id } }
    assert_redirected_to program_url(@program)
  end

  test "should destroy program" do
    assert_difference('Program.count', -1) do
      delete program_url(@program)
    end

    assert_redirected_to programs_url
  end
end
