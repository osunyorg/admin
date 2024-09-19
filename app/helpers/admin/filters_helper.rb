module Admin::FiltersHelper

  def filters_panel(current_path: '', active_filters_count: 0, &block)
    render  layout: "admin/application/filters_panel",
            locals: {
              current_path: current_path,
              active_filters_count: active_filters_count
            } do
      capture(&block)
    end
  end

  def active_filters_count
    return 0 unless params[:filters]
    params[:filters].to_unsafe_hash
                    .delete_if { |key, value| value.blank? || value == [''] }
                    .count(&:present?)
  end

  def render_filter_title(title)
    "<h5 class=\"text-primary mt-4\">#{h(title)}</h5>".html_safe
  end

  def render_filter(f, type, name, options = {})
    options[:input_class] = "#{options[:input_class]} filter".strip

    value = params.dig(:filters, name)

    public_send("render_#{type}_filter", f, name, value, options)
  end

  def render_string_filter(f, name, value, options)
    f.input name, 
            as: :string, 
            label: options[:label],
            required: false,
            input_html: { 
              value: value,
              class: options[:input_class]
            },
            wrapper_html: { class: options[:wrapper_class] },
            **options.except(:label, :input_class, :wrapper_class)
  end

  def render_boolean_filter(f, name, value, options)
    f.input name, 
            as: :boolean, 
            label: options[:label],
            required: false,
            checked: value == '1',
            input_html: { 
              include_hidden: false,
              checked: value == '1',
              class: 'filter'
            },
            wrapper_html: { class: options[:wrapper_class] }
  end

  def render_select_filter(f, name, value, options)
    options[:multiple] ||= false
    options[:collection] = options[:collection].map { |elmt| 
      if elmt.is_a?(String)
        [elmt, elmt]
      elsif elmt.is_a?(ActiveRecord::Base)
        elmt
      elsif elmt.is_a?(Hash)
        [elmt[:to_s], elmt[:id]]
      elsif elmt.is_a?(Array)
        elmt
      end
    }

    f.input name,
            as: :select,
            label: options[:label],
            collection: options[:collection],
            required: false,
            selected: value,
            include_blank: true,
            include_hidden: false,
            input_html: {
              multiple: options[:multiple],
              class: "#{options[:input_class]} form-select select2"
            },
            wrapper_html: { class: options[:wrapper_class] },
            **options.except(:label, :collection, :multiple, :input_class, :wrapper_class)
  end

  def render_radio_buttons_filter(f, name, value, options)
    options[:collection] = options[:collection].map { |elmt| elmt.is_a?(String) ? [elmt, elmt] : [elmt.is_a?(Hash) ? elmt[:to_s] : elmt.to_s, elmt[:id]] }

    f.input name, 
            as: :radio_buttons, 
            label: options[:label],
            collection: options[:collection],
            required: false,
            checked: value,
            input_html: { 
              checked:  value,
              class: 'filter'
            },
            wrapper_html: { class: options[:wrapper_class] }
  end

  def render_check_boxes_filter(f, name, value, options)
    options[:collection] = options[:collection].map { |elmt| elmt.is_a?(String) ? [elmt, elmt] : [elmt.is_a?(Hash) ? elmt[:to_s] : elmt.to_s, elmt[:id]] }
    
    f.input name, 
            as: :check_boxes, 
            label: options[:label],
            collection: options[:collection],
            required: false,
            checked: value,
            input_html: { 
              checked:  value,
              class: 'filter'
            },
            wrapper_html: { class: options[:wrapper_class] }
  end



  def render_grouped_select_filter(f, name, value, options)
    options[:multiple] ||= false

    f.input name, 
            as: :grouped_select, 
            label: options[:label],
            collection: options[:collection],
            group_method: :last,
            required: false,
            selected: value,
            include_blank: true,
            include_hidden: false,
            input_html: { 
              multiple: options[:multiple],
              class: "#{options[:input_class]} form-select select2"
            },
            wrapper_html: { class: options[:wrapper_class] }
    end

  def render_date_filter(f, name, value, options)
    f.input name, 
            as: :string, 
            label: options[:label],
            required: false,
            input_html: { 
              html5: true,
              value: value,
              class: "#{options[:input_class]} flatpickr",
              data: { format: t('admin.flatpickr.date.format') },
              autocomplete: 'one-time-code'
            },
            wrapper_html: { class: options[:wrapper_class] }
  end

end