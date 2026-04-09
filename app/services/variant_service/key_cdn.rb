class VariantService::KeyCdn < VariantService

  def url
    "https://#{keycdn_host}/#{blob.key}?#{query_string}"
  end

  def params
    @params ||= begin
      params = {}
      if should_resize?
        if should_crop?
          set_params_for_crop(params)
        elsif variant_width.present?
          params[:width] = max_width
          params[:enlarge] = 0
        elsif variant_height.present?
          params[:height] = max_height
          params[:enlarge] = 0
        end
      end
      params[:format] = format unless format_unchanged?
      params
    end
  end

  protected

  def set_params_for_crop(params)
    if variant_dimensions_smaller_than_original?
      # Simple crop, everything is smaller
      params[:width] = variant_width
      params[:height] = variant_height
    else
      # More complicated, 1 or both dimensions are larger, so we must find the biggest possible size with the ratio
      width = blob_width
      height = (width / crop_ratio).to_i
      if height > blob_height
        height = blob_height
        width = (height * crop_ratio).to_i
      end
      params[:width] = width
      params[:height] = height
    end
    params[:position] = position if position.present?
  end

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
