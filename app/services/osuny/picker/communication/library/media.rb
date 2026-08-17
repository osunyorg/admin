class Osuny::Picker::Communication::Library::Media < Osuny::Picker::Communication::Library::Base

  def objects
    @objects ||= university.communication_medias
  end

  def categories
    @categories ||= university.communication_media_categories
  end

  def collections
    @collections ||= university.communication_media_collections
  end

  def filters_before_categories
    filters_collections
  end

  def filters_after_categories
    filters_websites
  end

  protected

  def filters_collections
    @filters << {
      name: ::Communication::Media::Collection.model_name.human(count: 2, locale: language.iso_code),
      values: collections.map { |collection|
        {
          id: collection.id,
          name: collection.to_s_in(language),
          selected: collection.id.in?(params.to_s),
          query_parameters: "&filters[for_collection][]=#{collection.id}"
        }
      }
    }
  end

  def filters_websites
    @filters << {
      name: ::Communication::Website.model_name.human(count: 2, locale: language.iso_code),
      values: websites.map { |website| 
        {
          id: website.id,
          name: website.to_s_in(language),
          selected: website.id.in?(params.to_s),
          query_parameters: "&filters[for_website][]=#{website.id}"
        }
      }
    }
  end

  def websites
    ::Communication::Website.where(university: university,id: website_ids)
                            .ordered(language)
  end

  def website_ids
    ::Communication::File::Context.where(university: university)
                                  .pluck(:communication_website_id)
                                  .compact_blank
                                  .uniq
  end


end