class Osuny::Picker::Communication::File < Osuny::Picker

  def objects
    @objects ||= university.communication_files
  end

  def categories
    @categories ||= university.communication_file_categories
  end

  def filters_after_categories
    filters_filetypes
    filters_websites
    filters_creators
  end

  def sorts
    sort_add(I18n.t('communication.file.sort.alpha'), 'alpha')
    sort_add(I18n.t('communication.file.sort.date_desc'), 'date_desc')
    sort_add(I18n.t('communication.file.sort.date_asc'), 'date_asc')
    sort_add(I18n.t('communication.file.sort.size_desc'), 'size_desc')
    sort_add(I18n.t('communication.file.sort.size_asc'), 'size_asc')
  end

  protected

  # TODO
  def filters_filetypes
    @filters << {
      name: 'Types de fichiers',
      values: []
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

  def filters_creators
    @filters << {
      name: ::Communication::File.human_attribute_name(:created_by, locale: language.iso_code),
      values: creators.map { |user|
        {
          id: user.id,
          name: user.to_s,
          selected: user.id.in?(params.to_s),
          query_parameters: "&filters[for_creator][]=#{user.id}"
        }
      }
    }
  end

  def creators
    User.where(university: university, id: creator_ids)
        .ordered
  end

  def creator_ids
    objects.pluck(:created_by_id).compact_blank.uniq
  end
end