class Osuny::Picker::Communication::Library::File < Osuny::Picker::Communication::Library::Base

  def objects
    @objects ||= university.communication_files
  end

  def categories
    @categories ||= university.communication_file_categories
  end

  def filters_after_categories
    filters_filetypes unless accept_restricted?
    filters_websites
    filters_creators
  end

  def sorts
    sort_add(:date_desc)
    sort_add(:date_asc)
    sort_add(:size_desc)
    sort_add(:size_asc)
    sort_add(:alpha)
  end

  protected

  def filters_filetypes
    @filters << {
      name: I18n.t('admin.communication.file_types.title', locale: language.iso_code),
      values: ::  Communication::File.filetypes_present_in(objects).map { |filetype|
        {
          id: filetype,
          name: I18n.t("admin.communication.file_types.#{filetype}", locale: language.iso_code),
          selected: filetype.to_s.in?(params.to_s),
          query_parameters: "&filters[for_filetype][]=#{filetype}"
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