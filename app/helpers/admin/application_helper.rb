module Admin::ApplicationHelper
  def show_link_inline(object, **options)
    link_to_if  can?(:read, object),
                object.to_s.truncate(50),
                polymorphic_url_param(object, **options)
  end

  def show_link(object, **options)
    link_to_if  can?(:read, object),
                options.delete(:label) || 'Voir',
                polymorphic_url_param(object, **options),
                class: button_classes
  end

  def edit_link(object, **options)
    return unless can?(:update, object)
    link_to options.delete(:label) || 'Modifier',
            polymorphic_url_param(object, prefix: :edit, **options),
            class: button_classes
  end

  def destroy_link(object, **options)
    return unless can?(:destroy, object)
    link_to options.delete(:label) || 'Supprimer',
            polymorphic_url_param(object, **options),
            method: :delete,
            data: { confirm: 'Êtes-vous certain ?' },
            class: button_classes_danger
  end

  def create_link(object_class, **options)
    return unless can?(:create, object_class)
    object_class_sym = object_class.name.underscore.gsub('/', '_').to_sym

    link_to options.delete(:label) || 'Créer',
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

  def submit(form)
    form.button :submit,
                'Enregistrer',
                class: button_classes('mt-3'),
                form: form.options.dig(:html, :id)
  end

  private

  def polymorphic_url_param(object_or_class, **options)
    prefix = options.fetch(:prefix, nil)
    namespace = options.fetch(:namespace, :admin)
    url_options = options.fetch(:url_options, {})

    [prefix, namespace, object_or_class, url_options].compact
  end
end
