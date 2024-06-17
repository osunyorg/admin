class Importers::Api::Osuny::Communication::Website::Agenda::Event < Importers::Api::Osuny::Communication::Website::Base

  protected

  def import
    import_params
    import_blocks
    import_categories
    import_featured_image
  end

  def object
    @object ||= website.events.where(
      university: university,
      website: website,
      migration_identifier: migration_identifier,
      language: language
    ).first_or_initialize
  end

  def import_params
    object.title = Importers::Cleaner.clean_string params[:title]
    object.subtitle = Importers::Cleaner.clean_string params[:subtitle]
    object.summary = Importers::Cleaner.html_to_string params[:summary]
    object.from_day = params[:from_day]
    object.from_hour = params[:from_hour]
    object.created_at = params[:created_at]
    object.published = params[:published] || false
    object.save
  end

  def import_categories
    categories.each do |c|
      category = find_or_create_category c
      next if category.nil? || category.in?(object.categories)
      object.categories << category
    end
  end

  def import_featured_image
    image = params['image']
    return if image.blank?
    # Not twice
    return if object.featured_image.attached? 
    io = URI.open(image)
    filename = File.basename(image).split('?').first
    object.featured_image.attach(io: io, filename: filename)
  rescue
    puts "Attach image failed"
  end

  def find_or_create_category(data)
    if data.has_key? 'name'
      website.agenda_categories.where(
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