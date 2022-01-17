module Admin::ApplicationHelper
  def show_link_inline(object, **options)
    link_to_if  can?(:read, object),
                object.to_s.truncate(50),
                polymorphic_url_param(object, **options)
  end

  def show_link(object, **options)
    link_to_if  can?(:read, object),
                options.delete(:label) || t('show'),
                polymorphic_url_param(object, **options),
                class: button_classes
  end

  def edit_link(object, **options)
    return unless can?(:update, object)
    link_to options.delete(:label) || t('edit'),
            polymorphic_url_param(object, prefix: :edit, **options),
            class: button_classes
  end

  def destroy_link(object, **options)
    return unless can?(:destroy, object)
    link_to options.delete(:label) || t('delete'),
            polymorphic_url_param(object, **options),
            method: :delete,
            data: { confirm: options.delete(:confirm_message) || t('please_confirm') },
            class: button_classes_danger
  end

  def create_link(object_class, **options)
    return unless can?(:create, object_class)
    object_class_sym = object_class.name.underscore.gsub('/', '_').to_sym

    link_to options.delete(:label) || t('create'),
            polymorphic_url_param(object_class_sym, prefix: :new, **options),
            class: button_classes
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

  def table_classes
    'table table-hover'
  end

  def submit(form)
    form.button :submit,
                t('save'),
                class: button_classes,
                form: form.options.dig(:html, :id)
  end

  def prepare_html_for_static(html, university)
    text = html.to_s
    text = sanitize text,
                    tags: %w(table figure figcaption strong em b i u p code pre tt samp kbd var sub sup dfn cite big small address hr br span h1 h2 h3 h4 h5 h6 ul ol li dl dt dd abbr acronym a img blockquote del ins),
                    attributes: %w(rel  href src srcset width height alt cite datetime title class name xml:lang abbr style target)
    text.gsub! "\r", ''
    text.gsub! "\n", ' '
    text.gsub! "/rails/active_storage", "#{university.url}/rails/active_storage"
    sanitize text
  end

  def prepare_text_for_static(text)
    # Beware, it works only at level one, with 2 spaces
    indentation = '  '
    text = strip_tags text.to_s
    text.gsub! "\r\n", "\n" # Remove useless \r
    text.gsub! "\n", "\n#{indentation}" # Indent properly to avoid broken frontmatter
    text.chomp
  end

  def collection_tree(list, except = nil)
    collection = []
    list.root.ordered.each do |object|
      collection.concat(object.self_and_children(0))
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

  private

  def polymorphic_url_param(object_or_class, **options)
    prefix = options.fetch(:prefix, nil)
    namespace = options.fetch(:namespace, :admin)
    url_options = options.fetch(:url_options, {})

    [prefix, namespace, object_or_class, url_options].compact
  end
end
