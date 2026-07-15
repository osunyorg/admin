class Communication::Website::MoveToUniversityJob < Communication::Website::BaseJob
  def execute
    new_university_id = options[:new_university_id]
    website.move_to_university_safely(new_university_id)
  end
end
