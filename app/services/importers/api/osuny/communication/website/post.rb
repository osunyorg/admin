class Importers::Api::Osuny::Communication::Website::Post < Importers::Api::Osuny::Communication::Website::Base

  protected

  def import
    object.update post_params
    object.save
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

  def post_params
    ActionController::Parameters.new({ post: params })
      .require(:post)
      .permit(:title, :language, :meta_description, :summary)
  end
end