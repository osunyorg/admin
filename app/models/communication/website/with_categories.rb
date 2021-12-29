module Communication::Website::WithCategories
  extend ActiveSupport::Concern

  included do

    def set_programs_categories!
      programs_root_category = categories.where(is_programs_root: true).first_or_create(
        name: 'Offre de formation',
        slug: 'offre-de-formation',
        is_programs_root: true,
        university_id: university.id,
        skip_github_publication: true
      )
      programs_categories = [programs_root_category, programs_categories_level(programs_root_category, about.programs.root.ordered)].flatten
      github.send_batch_to_website(programs_categories, message: '[Category] Set programs categories.')
    end

    protected

    def programs_categories_level(parent_category, programs)
      programs.map.with_index do |program, index|
        program_category = categories.where(program_id: program.id).first_or_initialize(
          name: program.name,
          slug: program.name.parameterize,
          university_id: university.id
        )
        program_category.parent = parent_category
        program_category.position = index + 1
        program_category.skip_github_publication = true
        program_category.save
        program_children = about.programs.where(parent_id: program.id).ordered
        [program_category, programs_categories_level(program_category, program_children)].flatten
      end
    end

  end
end
