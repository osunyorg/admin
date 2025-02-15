module Communication::Website::WithProgramCategories
  extend ActiveSupport::Concern

  included do
    after_save_commit :set_programs_categories, if: -> (website) { website.has_education_programs? }
  end

  def set_programs_categories
    Communication::Website::SetProgramsCategoriesJob.perform_later(id)
  end

  def set_programs_categories_safely
    categories_collections.each do |objects|
      programs_root_category = set_programs_categories_root_for!(objects)
      original_language = programs_root_category.original_localization.language
      set_programs_categories_at_level_for!(
        objects,
        programs_root_category,
        education_programs.root.ordered(original_language),
        original_language
      )
    end
  rescue
  end

  protected

  def categories_collections
    collections = []
    collections << page_categories
    collections << post_categories if feature_posts?
    collections << agenda_categories if feature_agenda?
    collections << portfolio_categories if feature_portfolio?
    collections
  end

  def set_programs_categories_root_for!(objects)
    # 1. Vérifier qu'une catégorie "is_programs_root = true" existe
    # 2. Si elle n'existe pas, la créer
    # 3. Pour chaque langue, vérifier qu'une localisation existe, sinon la créer
    root_category = objects.where(is_programs_root: true)
                           .first_or_create(university_id: university_id, is_taxonomy: true)
    languages.each do |language|
      root_category.localizations
                   .where(language: language)
                   .first_or_create(
                      name: I18n.t(
                        'admin.education.programs.categories.root_name',
                        locale: language.iso_code
                      )
                   )
    end
    root_category
  end

  def set_programs_categories_at_level_for!(objects, parent_category, programs, language)
    programs.map.with_index do |program, index|
      category = objects.where(program_id: program.id)
                        .first_or_initialize(university_id: university.id)
      category.parent = parent_category
      category.position = index + 1
      category.save
      languages.each do |language|
        category_l10n = category.localizations.where(language: language).first_or_initialize
        category_l10n.name = program.to_s_in(language)
        category_l10n.save
      end
      children = education_programs.where(parent_id: program.id).ordered(language)
      set_programs_categories_at_level_for!(objects, category, children, language)
    end
  end
end