class Osuny::Picker::Communication::File < Osuny::Picker

  def objects
    @objects ||= university.communication_files
  end

  def categories
    @categories ||= university.communication_file_categories
  end

  # TODO
  def filters_before_categories
    @filters << {
      name: 'Types de fichiers',
      values: []
    }
    @filters << {
      name: ::Communication::Website.model_name.human(count: 2, locale: language.iso_code),
      values: []
    }
    @filters << {
      name: User.model_name.human(count: 2, locale: language.iso_code),
      values: []
    }
  end

  def sorts
    sort_add(I18n.t('communication.file.sort.alpha'), 'alpha')
    sort_add(I18n.t('communication.file.sort.date_desc'), 'date_desc')
    sort_add(I18n.t('communication.file.sort.date_asc'), 'date_asc')
    sort_add(I18n.t('communication.file.sort.size_desc'), 'size_desc')
    sort_add(I18n.t('communication.file.sort.size_asc'), 'size_asc')
  end

end