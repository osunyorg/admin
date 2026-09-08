class Ftp
  attr_reader :host, :port, :username, :password

  def initialize(host, port, username, password)
    @host = host
    @port = port
    @username = username
    @password = password
  end

  def send_blob(blob, directory, filename)
    manage_directory(directory)
    send(blob, filename)
  rescue => e
    Rails.logger.error("Échec de la synchronisation FTP vers #{host.inspect} : #{e.class} #{e.message}")
    raise
  ensure
    server.close
  end

  def send_text(text, path)
    file = ::Tempfile.new
    file.write(text)
    file.rewind
    server.puttextfile(file, path)
    file.unlink
  end

  def move(root_path, from_path, to_path)
    from = "#{root_path}#{from_path}"
    to = "#{root_path}#{to_path}"
    server.rename(from, to)
  end

  protected

  def server
    unless @server
      @server = Net::FTP.new
      @server.open_timeout = 10
      @server.read_timeout = 10
      @server.connect(host, port)
      @server.login(username, password)
    end
    @server
  end

  # Se déplace dans le répertoire indiqué
  # Crée les répertoires manquants
  def manage_directory(path)
    server.chdir('/')
    path.split('/').reject(&:blank?).each do |part|
      begin
        server.chdir(part)
      rescue Net::FTPPermError
        server.mkdir(part)
        server.chdir(part)
      end
    end
  end

  def send(blob, filename)
    blob.open do |file|
      server.putbinaryfile(file.path, filename)
    end
  end

  def close
    server.close
  end
end