module Communication::Website::WithProgramCategories
  extend ActiveSupport::Concern

  included do
    after_save_commit :set_programs_categories!, if: -> (website) { website.has_education_programs? }
  end

  # TODO : I18n
  # Actuellement, on ne crée que dans la langue par défaut du website, on ne gère pas les autres langues
  def set_programs_categories!
    [post_categories, agenda_categories].each do |objects|
      programs_root_category = set_root_programs_categories_for!(objects)
      set_programs_categories_at_level_for! objects, programs_root_category, education_programs.root.ordered
    end
  rescue
  end

  protected

  def set_root_programs_categories_for!(objects)
    programs_root_category = objects.for_language_id(default_language_id).where(is_programs_root: true).first_or_create(
      name: 'Offre de formation',
      slug: 'offre-de-formation',
      is_programs_root: true,
      university_id: university.id
    )
    programs_root_category
  end

  def set_programs_categories_at_level_for!(objects, parent_category, programs)
    programs.map.with_index do |program, index|
      category = objects.for_language_id(default_language_id).where(program_id: program.id).first_or_initialize(
        name: program.name,
        slug: program.name.parameterize,
        university_id: university.id
      )
      category.parent = parent_category
      category.position = index + 1
      category.save
      children = education_programs.where(parent_id: program.id).ordered
      set_programs_categories_at_level_for! objects, category, children
    end
  end
end