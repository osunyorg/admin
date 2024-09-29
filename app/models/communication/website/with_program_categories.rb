module Communication::Website::WithProgramCategories
  extend ActiveSupport::Concern

  included do
    after_save_commit :set_programs_categories, if: -> (website) { website.has_education_programs? }
  end

  def set_programs_categories
    Communication::Website::SetProgramsCategoriesJob.perform_later(id)
  end

  def set_programs_categories_safely
    [post_categories, agenda_categories].each do |objects|
      programs_root_category = set_programs_categories_root_for!(objects)
      # TODO L10N : Remove tmp_original
      set_programs_categories_at_level_for! objects.tmp_original, programs_root_category, education_programs.root.tmp_original.ordered
    end
  rescue
  end

  protected

  def set_programs_categories_root_for!(objects)
    # 1. Vérifier qu'une catégorie "is_programs_root = true" existe
    # 2. Si elle n'existe pas, la créer
    # 3. Pour chaque langue, vérifier qu'une localisation existe, sinon la créer
    # TODO L10N : Remove tmp_original
    root_category = objects.tmp_original.where(is_programs_root: true).first_or_create(university_id: university_id)
    languages.each do |language|
      root_category.localizations.where(language: language).first_or_create(
        name: I18n.t('admin.education.programs.categories.root_name', locale: language.iso_code)
      )
    end
    root_category
  end



  def set_programs_categories_at_level_for!(objects, parent_category, programs)
    programs.map.with_index do |program, index|
      category = objects.tmp_original
                        .where(program_id: program.id)
                        .first_or_initialize(university_id: university.id)
      category.parent = parent_category
      category.position = index + 1
      category.save
      languages.each do |language|
        category.localizations.where(language: language).first_or_create(
          name: program.to_s_in(language)
        )
      end
      # TODO L10N : Remove tmp_original
      children = education_programs.tmp_original.where(parent_id: program.id).ordered
      set_programs_categories_at_level_for! objects, category, children
    end
  end
end