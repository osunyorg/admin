module Api::Osuny::ApplicationController::WithResourceParams
  extend ActiveSupport::Concern

  protected

  def l10n_permitted_keys
    raise NoMethodError, 'You must implement this method in your controller'
  end

  def set_l10n_attributes(base_params, resource)
    l10ns_attributes = base_params.delete(:localizations)
    base_params[:localizations_attributes] = []
    l10ns_attributes.each do |language_iso_code, l10n_params|
      l10n_permitted_params = l10n_params.permit(*l10n_permitted_keys)

      l10n_permitted_params[:language_id] = Language.find_by(iso_code: language_iso_code)&.id

      existing_resource_l10n = resource.localizations.find_by(
        migration_identifier: l10n_permitted_params[:migration_identifier],
        language_id: l10n_permitted_params[:language_id]
      ) if resource&.persisted?
      l10n_permitted_params[:id] = existing_resource_l10n.id if existing_resource_l10n.present?

      set_featured_image_to_l10n_params(l10n_permitted_params, l10n: existing_resource_l10n)

      blocks_attributes = l10n_permitted_params.delete(:blocks)
      l10n_permitted_params[:blocks_attributes] = blocks_attributes.map do |block_params|
        existing_block = existing_resource_l10n.blocks.find_by(migration_identifier: block_params[:migration_identifier]) if existing_resource_l10n.present?
        block_params[:id] = existing_block.id if existing_block.present?
        block_params
      end if blocks_attributes.present?

      base_params[:localizations_attributes] << l10n_permitted_params
    end
  end

  def set_featured_image_to_l10n_params(l10n_params, l10n: nil)
    featured_image_data = l10n_params.delete(:featured_image)
    return unless featured_image_data.present?
    l10n_params[:featured_image_alt] = featured_image_data[:alt] if featured_image_data.has_key?(:alt)
    l10n_params[:featured_image_credit] = featured_image_data[:credit] if featured_image_data.has_key?(:credit)
    l10n_params[:featured_image_delete] = '1' if featured_image_data[:_destroy]
    featured_image_url = featured_image_data[:url]
    # No image to upload
    return unless featured_image_url.present?
    # Image already uploaded
    return if l10n.present? && l10n.featured_image.attached? && l10n.featured_image.blob.metadata[:source_url] == featured_image_url
    l10n_params[:featured_image] = {
      io: URI.parse(featured_image_url).open,
      filename: File.basename(URI.parse(featured_image_url).path),
      metadata: { source_url: featured_image_url }
    }
  end
end