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
      language = Language.find_by(iso_code: language_iso_code)
      next unless language.present?

      l10n_permitted_params = l10n_params
                                .permit(*l10n_permitted_keys)
                                .merge({ language_id: language.id })

      existing_resource_l10n = resource.localizations.find_by(
        migration_identifier: l10n_permitted_params[:migration_identifier],
        language_id: l10n_permitted_params[:language_id]
      ) if resource&.persisted?
      l10n_permitted_params[:id] = existing_resource_l10n.id if existing_resource_l10n.present?

      set_featured_image_to_l10n_params(l10n_permitted_params, l10n: existing_resource_l10n)
      set_blocks_attributes_to_l10n_params(l10n_permitted_params, l10n: existing_resource_l10n)
      set_aliases_attributes_to_l10n_params(l10n_permitted_params, l10n: existing_resource_l10n)

      base_params[:localizations_attributes] << l10n_permitted_params
    end
  end

  def set_featured_image_to_l10n_params(l10n_params, l10n: nil)
    featured_image_data = l10n_params.delete(:featured_image)
    return unless featured_image_data.present?
    l10n_params[:featured_image_alt] = featured_image_data[:alt] if featured_image_data.has_key?(:alt)
    l10n_params[:featured_image_credit] = featured_image_data[:credit] if featured_image_data.has_key?(:credit)
    l10n_params[:featured_image_delete] = '1' if featured_image_data[:_destroy]
    if featured_image_data[:blob_id].present?
      # If we send a blob_id, we attach it to the localization
      blob = current_university.active_storage_blobs.find_by(id: featured_image_data[:blob_id])
      l10n_params[:featured_image] = blob if blob.present?
    end
    # Set the image URL so that the object can delay the upload if needed
    l10n_params[:featured_image_new_url] = featured_image_data[:url]
  end

  def set_blocks_attributes_to_l10n_params(l10n_params, l10n: nil)
    blocks_attributes = l10n_params.delete(:blocks)
    return unless blocks_attributes.present?
    l10n_params[:blocks_attributes] = blocks_attributes.map do |block_params|
      existing_block = l10n.blocks.find_by(migration_identifier: block_params[:migration_identifier]) if l10n.present?
      block_params[:id] = existing_block.id if existing_block.present?
      block_params
    end
  end

  def set_aliases_attributes_to_l10n_params(l10n_params, l10n: nil)
    return unless @website # Aliases only work for direct objects.

    aliases_attributes = l10n_params.delete(:aliases)
    return unless aliases_attributes.present?
    l10n_params[:aliases_attributes] = aliases_attributes.map do |alias_params|
      clean_path = Communication::Website::Permalink.clean_path(alias_params[:path])
      existing_alias = l10n.aliases.find_by(website: @website, path: clean_path) if l10n.present?
      alias_params[:id] = existing_alias.id if existing_alias.present?
      alias_params[:path] = clean_path
      alias_params[:is_current] = false
      alias_params[:website_id] = @website.id
      alias_params
    end
  end

  def nested_aliases_params
    { aliases: [:path, :_destroy] }
  end

  def nested_blocks_params
    { blocks: [:migration_identifier, :template_kind, :title, :position, :published, :html_class, :_destroy, data: {}] }
  end
end
