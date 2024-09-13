module Admin::OsunyHelper

  def osuny_panel(title = nil, subtitle: nil, action: nil, image: nil, small: false, classes: '', &block)
    render  layout: "admin/application/components/panel",
            locals: {
              title: title,
              subtitle: subtitle,
              action: action,
              image: image,
              small: small,
              classes: classes
            } do
      capture(&block)
    end
  end

  def osuny_label(title, classes: '')
    raw "<label class=\"form-label #{classes}\">#{title}</label>"
  end

  def osuny_separator
    raw '<hr class="my-5">'
  end

  def osuny_thumbnail(object, large: false, cropped: true, classes: '')
    return if object.nil?
    image = object.respond_to?(:featured_image) ? object.featured_image
                                                : nil
    render  partial: "admin/application/components/thumbnail",
            locals: {
              image: image,
              initials: object.initials,
              large: large,
              cropped: cropped,
              classes: classes
            }
  end

  def osuny_thumbnail_localized(object, large: false, cropped: true, classes: '')
    l10n = object.best_localization_for(current_language)
    osuny_thumbnail l10n, 
                    large: large, 
                    cropped: cropped, 
                    classes: classes
  end

  def osuny_published(state)
    raw "<span class=\"osuny__published osuny__published--#{ state }\"></span>"
  end

  def osuny_published_localized(object)
    state = object.published_in?(current_language)
    osuny_published(state)
  end

  def osuny_property_show(object, property, kind, hide_blank: false)
    render  partial: "admin/application/property/#{kind}",
            locals: {
              object: object,
              property: property,
              hide_blank: hide_blank
            }
  end

  def osuny_property_show_text(object, property, hide_blank: false)
    osuny_property_show(object, property, 'text', hide_blank: hide_blank)
  end

  def osuny_property_show_url(object, property, hide_blank: false)
    osuny_property_show(object, property, 'url', hide_blank: hide_blank)
  end

  def osuny_property_show_boolean(object, property)
    osuny_property_show(object, property, 'boolean')
  end

  def osuny_link_localized(object, path, classes: '')
    l10n = object.localization_for(current_language)
    if l10n.present?
      name = l10n.to_s
      alert = ''
    else
      name = object.original_localization.to_s
      classes += ' text-muted fst-italic'
      alert = t('localization.creation_alert')
    end
    link_to name, path, class: classes.strip, data: { confirm: alert }
  end

  def osuny_link_localized_if(condition, object, path, classes: '')
    l10n = object.localization_for(current_language)
    if l10n.present?
      name = l10n.to_s
      alert = ''
    else
      name = object.original_localization.to_s
      classes += 'text-muted fst-italic'
      alert = t('localization.creation_alert')
    end
    link_to_if condition, name, path, class: classes.strip, data: { confirm: alert }
  end

  def osuny_collection(list, except: nil, localized: false, label_method: :to_s)
    collection = list.ordered(current_language).map do |object|
      [
        osuny_object_label(object, localized, label_method), 
        object.id
      ]
    end
    collection = collection.reject { |o| o.last == except.id } unless except.nil?
    collection
  end

  def osuny_collection_tree(list, except: nil, localized: false, label_method: :to_s)
    collection = osuny_collection_recursive(list.root, 0, localized, label_method)
    collection = collection.reject { |o| o.last == except.id } unless except.nil?
    collection
  end

  private

  def osuny_object_label(object, localized, label_method)
    object_for_label = localized ? object.best_localization_for(current_language) : object
    return 'na' if object_for_label.nil?
    label_method.respond_to?(:call) ? label_method.call(object_for_label)
                                    : object_for_label.public_send(label_method)
  end

  def osuny_collection_recursive(list, level, localized, label_method)
    collection = []
    list.ordered.each do |object|
      object_for_name = localized ? object.best_localization_for(current_language) : object
      name = label_method.respond_to?(:call) ? label_method.call(object_for_name)
                                             : object_for_name.public_send(label_method)
      label = sanitize("&nbsp;&nbsp;&nbsp;&nbsp;" * level + name)
      id = object.id
      collection << [label, id]
      collection.concat(
        osuny_collection_recursive(
          object.children.tmp_original, # TODO L10N : To remove
          level + 1,
          localized,
          label_method
        )
      )
    end
    collection
  end

end