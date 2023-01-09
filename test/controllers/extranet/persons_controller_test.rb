require "test_helper"

class Extranet::PersonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    host! "extranet.osuny"
    sign_in_with_2fa(alumnus)
  end

  def test_index
    get university_persons_path
    assert_response(:success)
  end

  def test_show
    get university_person_path(university_people(:alumnus))
    assert_response(:success)
  end
end
