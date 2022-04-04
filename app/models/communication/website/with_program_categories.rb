module Communication::Website::WithProgramCategories
  extend ActiveSupport::Concern

  included do
    after_save_commit :set_programs_categories!, if: -> (website) { website.has_education_programs? }
  end

  def set_programs_categories!
    programs_root_category = categories.where(is_programs_root: true).first_or_create(
      name: 'Offre de formation',
      slug: 'offre-de-formation',
      is_programs_root: true,
      university_id: university.id
    )
    set_programs_categories_at_level! programs_root_category, about.programs.root.ordered
  rescue
  end

  protected

  def set_programs_categories_at_level!(parent_category, programs)
    programs.map.with_index do |program, index|
      category = categories.where(program_id: program.id).first_or_initialize(
        name: program.name,
        slug: program.name.parameterize,
        university_id: university.id
      )
      category.parent = parent_category
      category.position = index + 1
      category.save
      children = about.programs.where(parent_id: program.id).ordered
      set_programs_categories_at_level! category, children
    end
  end
