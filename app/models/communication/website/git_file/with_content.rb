module Communication::Website::GitFile::WithContent
  extend ActiveSupport::Concern

  included do
    has_one_attached :current_content_file
  end

  def current_content
    return '' unless current_content_file.attached?
    @current_content ||= ActiveStorage::Utils.text_from_attachment(current_content_file)
  end

  def generate_content_safely
    return if up_to_date?
    @current_content = nil
    ActiveStorage::Utils.attach_from_text(current_content_file, computed_content, 'file.html')
    update(
      current_path: computed_path,
      current_sha: computed_sha,
      desynchronized: true,
      desynchronized_at: Time.zone.now
    )
  end

  def computed_path
    @computed_path ||= needs_deletion? ? nil : about.git_path(website)&.gsub(/\/+/, '/')
  end

  def computed_filename
    @computed_filename ||= File.basename(computed_path)
  rescue
    ''
  end

  def computed_content
    @computed_content ||= (about.nil? || computed_path.nil? ? '' : Static.render(template_static, about, website))
  end

  def computed_sha
    website.git_repository.computed_sha(computed_content)
  end

  protected

  def generate_content
    Communication::Website::GitFile::GenerateContentJob.perform_later(self)
  end

  def up_to_date?
    path_up_to_date? && content_up_to_date?
  end

  def path_up_to_date?
    current_path == previous_path
  end

  def content_up_to_date?
    current_content == computed_content
  end

  def needs_deletion?
    about.nil? || !about.try(:syncable?)
  end
end
