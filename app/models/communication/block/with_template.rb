module Communication::Block::WithTemplate
  extend ActiveSupport::Concern

  included do
    OPTION_PREFIX = 'option_'.freeze

    # Les numéros sont un peu en vrac
    # Dans l'idée, pour le futur
    # 1000 basic
    # 2000 storytelling
    # 3000 references
    # 4000 utilities
    enum :template_kind, {
      chapter: 50,
      image: 51,
      video: 52,
      embed: 53,
      datatable: 54,
      files: 55,
      key_figures: 56,
      contact: 57,
      programs: 58,
      persons: 100,
      organizations: 200,
      gallery: 300,
      testimonials: 400,
      posts: 500,
      pages: 600,
      timeline: 700,
      definitions: 800,
      call_to_action: 900,
      title: 1001,
      sound: 1005,
      features: 2010,
      agenda: 3100,
      projects: 3101,
      exhibitions: 3102,
      locations: 3200,
      papers: 3300,
      volumes: 3310,
      jobs: 3400,
      categories: 3500,
      license: 4040,
      links: 4050
    }, prefix: :template

    TEMPLATE_KINDS_WITH_NAME_OVERRIDE = {
      posts: :feature_posts_name,
      agenda: :feature_agenda_name,
      projects: :feature_portfolio_name,
      jobs: :feature_jobboard_name
    }

    # Used to purge images when unattaching them
    # template_blobs would be a better name, because there are files
    has_many_attached :template_images

    before_save :attach_template_blobs
  end

  def template
    @template ||= template_class.new self, self.attributes['data']
  end

  def template_reset!
    @template = nil
  end

  def template_name
    template_name_can_have_override? ? template_name_in_website : default_template_name
  end

  def options
    options = {}
    template.components_descriptions.map do |desc|
      property = desc[:property].to_s
      next unless property.start_with?(OPTION_PREFIX)
      property_without_prefix = property.remove(OPTION_PREFIX)
      options[property_without_prefix] = template.public_send(property)
    end
    options
  end

  protected

  def template_name_can_have_override?
    return false if template_website.nil?
    template_kind.to_sym.in?(TEMPLATE_KINDS_WITH_NAME_OVERRIDE.keys)
  end

  def template_name_in_website
    method = TEMPLATE_KINDS_WITH_NAME_OVERRIDE[template_kind.to_sym]
    template_website.send(method, language)
  end

  def template_website
    unless @template_website
      l10n = about
      object = l10n.try(:about)
      @template_website = object.try(:website)
    end
    @template_website
  end

  def default_template_name
    I18n.t("enums.communication.block.template_kind.#{template_kind}")
  end

  def template_class
    "Communication::Block::Template::#{template_kind.classify}".constantize
  end

  # FIXME @sebou
  # Could not find or build blob: expected attachable, got #<ActiveStorage::Blob id: "f4c78657-5062-416b-806f-0b80fb66f9cd", key: "gri33wtop0igur8w3a646llel3sd", filename: "logo.svg", content_type: "image/svg+xml", metadata: {"identified"=>true, "width"=>709, "height"=>137, "analyzed"=>true}, service_name: "scaleway", byte_size: 4137, checksum: "aZqqTYabP5+72ZeddcZ/2Q==", created_at: "2022-05-05 12:17:33.941505000 +0200", university_id: "ebf2d273-ffc9-4d9f-a4ee-a2146913d617">
  def attach_template_blobs
    # self.template_images = template.active_storage_blobs
  end

end
