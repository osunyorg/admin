class Importers::Api::Osuny::Communication::Website::Base

  attr_reader :university, :website, :params

  def initialize(university:, website:, params:)
    @university = university
    @website = website
    @params = params.to_unsafe_hash
    import
  end

  protected

  def import
    raise NoMethodError, "You must implement the `import` method in #{self.class.name}"
  end

  def object
    raise NoMethodError, "You must implement the `object` method in #{self.class.name}"
  end

  def language
    # TODO specific language set in params
    website.default_language
  end

  def migration_identifier
    @migration_identifier ||= params[:migration_identifier]
  end

  def blocks
    return [] unless params.has_key?(:blocks)
    @blocks ||= params[:blocks]
  end

  def import_blocks
    blocks.each do |b|
      migration_identifier = b[:migration_identifier]
      template_kind = b[:template_kind]
      block = object.blocks
                    .where(
                      university: university,
                      migration_identifier: migration_identifier,
                      template_kind: template_kind
                    )
                    .first_or_initialize
      block.title = b[:title]
      block.data = block.template.data.merge b[:data]
      block.save
    end
  end
end
