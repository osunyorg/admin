module Admin::OsunyStaticHelper

  def prepare_html_for_static(text)
    university = current_university || @website&.university || @about&.university
    html = Static::Html.new(text, about: @about, university: university).prepared
    # Les notes vont de 1 à n sur la page, il faut donc que l'index soit pour toute la page (tout le fichier static).
    # C'est pour cela qu'on passe par le helper, ce qui garde @index.
    prepare_notes html
  end

  def prepare_text_for_static(text, depth: 1)
    Static::Text.new(text, depth: depth, about: @about).prepared
  end

  def prepare_code_for_static(text, depth: 1)
    Static::Code.new(text, depth: depth, about: @about).prepared
  end

  def prepare_media_for_static(object, key)
    media = object[key]['id']
  rescue
    ''
  end

  def osuny_static_string(key, value, depth: 1)
    return if value.blank?
    indentation = '  ' * (depth-1)
    prepared = prepare_text_for_static(value)
    raw "#{indentation}#{key}: >-\n#{indentation}  #{prepared}"
  end

  def osuny_static_html(key, value, depth: 1)
    text = strip_tags(value.to_s)
    return if text.blank?
    indentation = '  ' * (depth-1)
    prepared = prepare_html_for_static(value)
    raw "#{indentation}#{key}: >-\n#{indentation}  #{prepared}"
  end

end