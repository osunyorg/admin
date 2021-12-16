module University::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many :education_programs, class_name: 'Education::Program', dependent: :destroy
    has_many :education_schools, class_name: 'Education::School', dependent: :destroy

    def list_of_programs
      all_programs = []
      education_programs.root.ordered.each do |program|
        all_programs.concat(program.self_and_children(0))
      end
      all_programs
    end

  end
end
