module Communication::File::Localization::WithFileServer
  extend ActiveSupport::Concern

  included do
    after_save :sync_to_file_server
  end

  def sync_to_file_server
    return unless university.file_server?
    Communication::File::SynchronizeWithFileServerJob.perform_later(self)
  end

  def file_server_url
    return unless university.file_server?
    "#{file_server.url}/#{file_server_path}"
  end

  def file_server_filename
    "#{slug}#{original_extension}"
  end

  def sync_to_file_server_safely
    create_file_server_directory_if_necessary(file_server_remote_directory)
    original_blob.open do |file|
      ftp.putbinaryfile(file.path, file_server_filename)
    end
  rescue => e
    Rails.logger.error("[Communication::File::Localization##{id}] Échec de la synchronisation FTP vers #{file_server&.ftp_host.inspect} : #{e.class} #{e.message}")
    raise
  ensure
    @ftp&.close
  end

  protected

  def file_server
    @file_server ||= university.file_server
  end

  def file_server_directory
    "#{created_at.year}"
  end

  def file_server_path
    "#{file_server_directory}/#{file_server_filename}"
  end

  def ftp
    unless @ftp
      @ftp = Net::FTP.new
      @ftp.open_timeout = 10
      @ftp.read_timeout = 10
      @ftp.connect(file_server.ftp_host, file_server.ftp_port)
      @ftp.login(file_server.ftp_username, file_server.ftp_password)
    end
    @ftp
  end

  def file_server_remote_directory
    "#{file_server.ftp_path}/#{file_server_directory}"
  end

  def create_file_server_directory_if_necessary(path)
    ftp.chdir('/')
    path.split('/').reject(&:blank?).each do |part|
      begin
        ftp.chdir(part)
      rescue Net::FTPPermError
        ftp.mkdir(part)
        ftp.chdir(part)
      end
    end
  end
end
