class Importers::Api::Osuny::Communication::Website::Page < Importers::Api::Osuny::Communication::Website::Base

  protected

  def import
    object.parent = parent
    object.update page_params
    object.save
    import_blocks
  end

  def home_page
    website.special_page(Communication::Website::Page::Home, language: language)
  end

  def parent
    parent_migration_identifier = params.dig(:parent, :migration_identifier)    
    @parent = page_with parent_migration_identifier if parent_migration_identifier
    @parent = home_page if @parent.nil?
    @parent
  end

  def object
    @object ||= page_with migration_identifier
  end

  def page_with(migration_identifier)
    website.pages.where(
      university: university,
      website: website,
      migration_identifier: migration_identifier,
      language: language
    ).first_or_initialize
  end

  def page_params
    ActionController::Parameters.new({ page: params })
      .require(:page)
      .permit(:title, :language, :meta_description, :summary)
  end
end