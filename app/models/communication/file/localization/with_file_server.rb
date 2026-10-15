module Communication::File::Localization::WithFileServer
  extend ActiveSupport::Concern

  included do
    validate  :file_server_slug_available,
              on: :redirection
    validates :file_server_slug,
              format: {
                with: /\A[a-z0-9\-]+\z/,
                message: I18n.t('slug_error')
              },
              on: :redirection

    before_validation :set_file_server_slug_if_empty?
    after_save :sync_to_file_server
    after_destroy :sync_to_file_server
    after_restore :sync_to_file_server
  end

  def sync_to_file_server
    return unless university.file_server?
    Communication::File::SynchronizeWithFileServerJob.perform_later(self)
  end

  def sync_to_file_server_safely
    if file_server_should_delete?
      file_server_delete!
    elsif file_server_should_create?
      file_server_create!
    elsif file_server_should_update?
      file_server_update!
    elsif file_server_should_move?
      file_server_move!
    end
    ftp.close
  end

  # rapport-annuel
  # file_server_slug

  # .pdf
  def file_server_extension
    "#{original_extension}"
  end

  # rapport-annuel.pdf
  def file_server_filename
    "#{file_server_slug}#{file_server_extension}"
  end

  # /fr/2026/
  def file_server_directory
    "/#{language.iso_code}/#{created_at.year}/"
  end

  # /fr/2026/rapport-annuel.pdf
  def file_server_path
    "#{file_server_directory}#{file_server_filename}"
  end

  # /fr/2026/rapport-annuel
  def file_server_path_without_extension
    "#{file_server_directory}#{file_server_slug}"
  end

  # /path-on-ftp-server/fr/2026/
  def file_server_remote_directory
    "#{file_server.ftp_path}#{file_server_directory}".gsub('//', '/')
  end

  # /path-on-ftp-server/fr/2026/rapport-annuel.pdf
  def file_server_remote_path
    "#{file_server.ftp_path}#{file_server_path}".gsub('//', '/')
  end

  # /path-on-ftp-server/fr/2026/rapport-annuel.pdf
  def file_server_remote_current_path
    "#{file_server.ftp_path}#{file_server_current_path}".gsub('//', '/')
  end

  # https://files.osuny.org/
  def file_server_base_url
    "#{file_server.url}/"
  end
  # https://files.osuny.org/fr/2026/
  def file_server_base_directory_url
    "#{file_server.url}#{file_server_directory}"
  end

  # https://files.osuny.org/fr/2026/rapport-annuel.pdf
  def file_server_url
    return unless university.file_server?
    "#{file_server.url}#{file_server_path}"
  end

  protected

  # Premier envoi
  def file_server_should_create?
    file_server_current_path.blank?
  end

  # Nouveau fichier
  def file_server_should_update?
    file_server_current_checksum != original_checksum
  end

  # Déplacement
  def file_server_should_move?
    file_server_current_path.present? &&
    file_server_current_path != file_server_path
  end

  # Suppression
  def file_server_should_delete?
    !published? || deleted?
  end

  # Le fichier n'est pas sur le ftp
  def file_server_create!
    ftp.send_blob(
      original_blob,
      file_server_remote_directory,
      file_server_filename
    )
    update_columns  file_server_current_path: file_server_path,
                    file_server_current_checksum: file_server_current_checksum
    send_htaccess
  end

  # On change de blob
  def file_server_update!
    file_server_delete!
    file_server_create!
  end

  # Le slug a changé, on bouge le fichier
  def file_server_move!
    ftp.move(
      file_server.ftp_path,
      file_server_current_path,
      file_server_path
    )
    update_columns  file_server_current_path: file_server_path
    send_htaccess
  end

  # On supprime le fichier
  def file_server_delete!
    ftp.delete(file_server_remote_current_path)
    update_columns  file_server_current_path: nil,
                    file_server_current_checksum: nil
    send_htaccess
  end

  def send_htaccess
    ftp.send_text(htaccess_content, htaccess_path)
  end

  def htaccess_content
    Static.render(htaccess_template_static, self, nil)
  end

  def htaccess_template_static
    'admin/communication/library/files/redirections/static'
  end

  def htaccess_path
    "#{file_server.ftp_path}.htaccess"
  end

  def set_file_server_slug_if_empty?
    return if file_server_slug.present?
    self.file_server_slug = slug
  end

  def ftp
    @ftp ||= ::Ftp.new(
      file_server.ftp_host,
      file_server.ftp_port,
      file_server.ftp_username,
      file_server.ftp_password
    )
  end

  def file_server
    @file_server ||= university.file_server
  end

  def file_server_slug_available
    taken = self.class
                .unscoped
                .where(
                  university_id: university_id,
                  file_server_slug: file_server_slug
                )
                .where(
                  "date_part('year', created_at) = ?",
                  created_at&.year
                )
                .where.not(id: id)
                .exists?
    errors.add(:file_server_slug, :taken) if taken
  end
end
