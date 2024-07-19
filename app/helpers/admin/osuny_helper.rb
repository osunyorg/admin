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

  def osuny_thumbnail(object, large: false, cropped: true, fit: false)
    image = object.respond_to?(:featured_image) ? object.featured_image
                                                : nil
    render  partial: "admin/application/components/thumbnail",
            locals: {
              image: image,
              initials: object.initials,
              large: large,
              cropped: cropped,
              fit: fit
            }
  end

  def osuny_published(object)
    raw "<span class=\"osuny__published osuny__published--#{ object.published? }\"></span>"
  end

end