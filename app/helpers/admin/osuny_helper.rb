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

  def osuny_published(state)
    raw "<span class=\"osuny__published osuny__published--#{ state }\"></span>"
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

end