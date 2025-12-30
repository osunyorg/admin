class VariantService::KeyCdn < VariantService

  def url
    "https://#{keycdn_host}/#{blob.key}?#{query_string}"
  end

  def params
    @params ||= begin
      params = {}
      # Resize and/or crop unless original size
      if variant_dimensions != blob_size
        if should_crop?
          params[:width] = variant_dimensions[0]
          params[:height] = variant_dimensions[1]
          params[:position] = position if position.present?
        elsif variant_dimensions[0].present?
          params[:width] = variant_dimensions[0]
          params[:enlarge] = 0
        elsif variant_dimensions[1].present?
          params[:height] = variant_dimensions[1]
          params[:enlarge] = 0
        end
      end
      params[:format] = format unless format_unchanged?
      params
    end
  end

  protected

  def keycdn_host
    ENV["KEYCDN_HOST"]
  end

  def query_string
    URI.encode_www_form(params)
  end

  # top, left... but not center :)
  def position
    gravity.in?([nil, 'center']) ? nil : gravity
  end

end
