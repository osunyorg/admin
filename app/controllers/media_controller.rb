class MediaController < ApplicationController
  def show
    @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
    # filename_with_transformations = params[:filename_with_transformations]
    # parts = filename_with_transformations.split('_')
    # transformations = { format: params[:format] }
    # dimensions = nil
    # loop do
    #   key, value = parts.pop(2)
    #   if ['crop', 'scale'].include?(key)
    #     transformations[key.to_sym] = value
    #   else
    #     dimensions = (value || key).split('x')
    #     dimensions << '' if dimensions.one?
    #     break
    #   end
    # end

    dimensions.map! { |dimension| dimension.to_i.to_s == dimension ? dimension.to_i : nil }
    dimensions = [
      @blob.metadata[:width],
      @blob.metadata[:height]
    ] unless dimensions.any? { |dimension| dimension.is_a?(Integer) }

    scale_value = transformations.delete(:scale).to_i
    dimensions.map! { |dimension| dimension * scale_value if dimension.is_a?(Integer) } if [2, 3].include? scale_value

    crop_value = transformations.delete(:crop)
    crop_parameter = gravity_per_crop.keys.detect { |gravity| gravity == crop_value }
    if crop_parameter.present?
      gravity = gravity_per_crop[crop_parameter] || 'Center'
      transformations.merge!({
        resize_to_fill: [*dimensions, { gravity: gravity }],
        crop: "#{dimensions.join('x')}+0+0"
      })
    else
      transformations.merge!({ resize_to_limit: dimensions })
    end

    render json: { transformations: transformations, url: url_for(@blob.variant(transformations)) }
  end

  protected

  def gravity_per_crop
    {
      'top' => 'North',
      'right' => 'East',
      'bottom' => 'South',
      'left' => 'West',
      'center' => 'Center'
    }
  end
end
