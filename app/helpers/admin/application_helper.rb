module Admin::ApplicationHelper
  def show_link_inline(object, **options)
    link_to_if  can?(:read, object),
                object.to_s.truncate(50),
                polymorphic_url_param(object, **options)
  end

  def show_link(object, html_classes: button_classes, **options)
    link_to_if  can?(:read, object),
                options.delete(:label) || t('show'),
                polymorphic_url_param(object, **options),
                class: html_classes
  end

  def edit_link(object, html_classes: button_classes, **options)
    return unless can?(:update, object)
    link_to options.delete(:label) || t('edit'),
            polymorphic_url_param(object, prefix: :edit, **options),
            class: html_classes
  end

  def destroy_link(object, html_classes: button_classes_danger, **options)
    return unless can?(:destroy, object)
    link_to options.delete(:label) || t('delete'),
            polymorphic_url_param(object, **options),
            method: :delete,
            data: { confirm: options.delete(:confirm_message) || t('please_confirm') },
            class: html_classes
  end

  def create_link(object_class, html_classes: button_classes, **options)
    return unless can?(:create, object_class)
    object_class_sym = object_class.name.underscore.gsub('/', '_').to_sym

    link_to options.delete(:label) || t('create'),
            polymorphic_url_param(object_class_sym, prefix: :new, **options),
            class: html_classes
  end

  def duplicate_link(object, html_classes: nil)
    return unless can?(:create, object)
    html_classes = button_classes('btn-light') if html_classes.nil?
    link_to t('admin.duplicate'),
            [:duplicate, :admin, object],
            method: :post,
            data: { confirm: t('please_confirm') },
            class: html_classes
  end

  def preview_link
    raw "<button  class=\"btn btn-light btn-xs\"
                  type=\"button\"
                  data-bs-toggle=\"modal\"
                  data-bs-target=\"#preview\"
                  aria-controls=\"preview\">#{ t 'preview.button'}</button>"
  end

  def publish_link(object)
    return if object.published || cannot?(:publish, object)
    link_to t('admin.communication.website.publish.button'),
            [:publish, :admin, object],
            method: :post,
            class: button_classes
  end

  def static_link(path)
    return unless current_user.server_admin?
    raw "<a href=\"#{path}\" class=\"btn btn-light btn-xs\">#{t 'static' }</a>"
  end

  def button_classes(additional = '', **options)
    classes = "btn btn-primary btn-xs #{additional}"
    classes += ' disabled' if options[:disabled]
    classes
  end

  def button_classes_danger(**options)
    classes = 'btn btn-danger btn-xs'
    classes += ' disabled' if options[:disabled]
    classes
  end

  def table_classes(with_actions: true)
    classes = 'table'
    classes += ' table--with-actions' if with_actions
    classes
  end

  def table_actions_cell
    'text-end pe-0'
  end

  def submit(form)
    form.button :submit,
                t('save'),
                class: button_classes,
                form: form.options.dig(:html, :id)
  end

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

  def has_content?(html)
    strip_tags(html.to_s).present?
  end

  def indent(text, depth)
    indentation = '  ' * depth
    # Remove useless \r
    text.gsub! "\r\n", "\n"
    # Replace lonely \r
    text.gsub! "\r", "\n"
    # Indent properly to avoid broken frontmatter, with 2 lines so the linebreak work
    text.gsub! "\n", "\n#{indentation}\n#{indentation}"
    text.chomp!
    text
  end

  def prepare_media_for_static(object, key)
    media = object[key]['id']
  rescue
    ''
  end

  def collection(list)
    list.ordered.map do |e|
      {
        label: e.to_s,
        id: e.id
      }
    end
  end

  def collection_tree(list, except = nil)
    collection = []
    list.root.ordered.each do |object|
      collection.concat(object.self_and_children(0))
    end
    collection = collection.reject { |o| o[:id] == except.id } unless except.nil?
    collection
  end

  def translatable_collection_tree(list, language, except = nil)
    collection = []
    list.in_closest_language_id(language.id).root.ordered.each do |object|
      collection.concat(object.self_and_translatable_children(language, 0))
    end
    collection = collection.reject { |o| o[:id] == except.id } unless except.nil?
    collection
  end

  def collection_tree_for_checkboxes(list, except = nil)
    collection = collection_tree(list, except)
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

  def time_zones_for_select
    # Collection items are like ["(GMT+01:00) Paris", "Europe/Paris"]
    # Label specifies the UTC offset
    # Value is in tz database format
    time_zones = ActiveSupport::TimeZone.all.sort
    time_zones.map { |time_zone|
      [
        time_zone.to_s,
        time_zone.tzinfo.name
      ]
    }
  end

  private

  def polymorphic_url_param(object_or_class, **options)
    prefix = options.fetch(:prefix, nil)
    namespace = options.fetch(:namespace, :admin)
    url_options = options.fetch(:url_options, {})

    [prefix, namespace, object_or_class, url_options].compact
  end
end
