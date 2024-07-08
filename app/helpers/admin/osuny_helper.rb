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

  def osuny_thumbnail(object, large: false, cropped: true)
    image = object.respond_to?(:featured_image) ? object.featured_image
                                                : nil
    render  partial: "admin/application/components/thumbnail",
            locals: {
              image: image,
              initials: object.initials,
              large: large,
              cropped: cropped
            }
  end

  def osuny_thumbnail_localized(object, large: false, cropped: true)
    l10n = object.best_localization_for(current_language)
    osuny_thumbnail(l10n, large: large, cropped: cropped)
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

  def osuny_link_localized(object, path)
    l10n = object.localization_for(current_language)
    classes = 'stretched-link '
    if l10n.present?
      name = l10n.to_s
      classes += 'text-black'
      alert = ''
    else
      name = object.original_localization.to_s
      classes += 'text-muted fst-italic'
      alert = t('localization.creation_alert')
    end
    link_to name, path, class: classes, data: { confirm: alert }
  end

  def osuny_collection(list, except: nil, tree: false, localized: false)
    collection = []
    list.root.ordered.each do |object|
      collection.concat(object.self_and_children(0))
    end
    collection = collection.reject { |o| o[:id] == except.id } unless except.nil?
    collection
    #
    collection = collection_tree_localized(list, except)
    collection.map { |object|
      [
        sanitize(object[:label]),
        object[:id],
        {
          data: {
            parent: object[:parent_id]
          }
        }
      ]
    }
  end

end