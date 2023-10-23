class Importers::Api::Osuny::Communication::Website::Post < Importers::Api::Osuny::Communication::Website::Base

  protected

  def import
    import_params
    import_blocks
    import_categories
  end

  def object
    @object ||= website.posts.where(
      university: university,
      website: website,
      migration_identifier: migration_identifier,
      language: language
    ).first_or_initialize
  end

  def import_params
    object.title = Importers::Cleaner.clean_string params[:title]
    object.summary = Importers::Cleaner.html_to_string params[:summary]
    object.published_at = params[:published_at]
    object.created_at = object.published_at
    object.save
  end

  def import_categories
    categories.each do |c|
      category = find_or_create_category c
      next if category.nil? || category.in?(object.categories)
      object.categories << category
    end
  end

  def find_or_create_category(data)
    if data.has_key? 'name'
      website.categories.where(
        university: university,
        website: website,
        name: data['name'],
        language: language
      ).first_or_create
    end
  end

  def categories
    return [] unless params.has_key?(:categories)
    @categories ||= params[:categories]
  end
end