module Communication::File::Localization::WithFileServer
  extend ActiveSupport::Concern

  included do
    after_save :sync_to_file_server
  end

  def sync_to_file_server
    return unless university.file_server?
    Communication::File::SynchronizeWithFileServerJob.perform_later(self)
  end

  def sync_to_file_server_safely
    ftp.send_blob(
      original_blob,
      file_server_remote_directory,
      file_server_filename
    )
  end

  # https://files.osuny.org/fr/2026/rapport-annuel.pdf
  def file_server_url
    return unless university.file_server?
    "#{file_server.url}/#{file_server_path}"
  end

  # rapport-annuel.pdf
  def file_server_filename
    "#{slug}#{original_extension}"
  end

  protected

  def file_server
    @file_server ||= university.file_server
  end

  # fr/2026
  def file_server_directory
    "#{language.iso_code}/#{created_at.year}"
  end

  # fr/2026/rapport-annuel.pdf
  def file_server_path
    "#{file_server_directory}/#{file_server_filename}"
  end

  # /path-on-ftp-server/fr/2026/rapport-annuel.pdf
  def file_server_remote_directory
    "#{file_server.ftp_path}/#{file_server_directory}"
  end

  def ftp
    @ftp ||= ::Ftp.new(
      file_server.ftp_host,
      file_server.ftp_port,
      file_server.ftp_username,
      file_server.ftp_password
    )
  end

end
