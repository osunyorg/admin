class Git::Providers::Gitlab < Git::Providers::Abstract
  DEFAULT_ENDPOINT = 'https://gitlab.com/api/v4'.freeze
  COMMIT_BATCH_SIZE = 100

  def url
    base_url = endpoint.gsub("/api/v4", "")
    "#{base_url}/#{repository}"
  end

  def create_file(path, content)
    batch << {
      action: 'create',
      file_path: path,
      content: content
    }
  end

  def update_file(path, previous_path, content)
    file = find previous_path
    if file.present? && previous_path != path
      batch << {
        action: 'move',
        file_path: path,
        previous_path: previous_path
      }
    end
    batch << {
      action: 'update',
      file_path: path,
      content: content
    }
  end

  def destroy_file(path)
    file = find path
    return if file.nil?
    batch << {
      action: 'delete',
      file_path: path,
    }
  end

  def update_theme
    raise NotImplementedError
  end

  def init_from_template(name)
    raise NotImplementedError
  end

  def update_secrets(secrets)
    raise NotImplementedError
  end

  def push(commit_message)
    return if !valid? || batch.empty?
    client.create_commit  repository,
                          branch,
                          commit_message,
                          batch
    true
  end

  def computed_sha(string)
    OpenSSL::Digest::SHA256.hexdigest string
  end

  # https://gitlab.com/gitlab-org/gitlab/-/issues/23504
  # TODO : Il faudrait, comme sur GitHub, stocker le tree pour éviter N requêtes pour N objets.
  def git_sha(path)
    begin
      file = find path
      sha = file['content_sha256']
    rescue
      sha = nil
    end
    sha
  end

  def valid?
    return false unless super
    begin
      client.project(repository)
      true
    rescue Gitlab::Error::Unauthorized
      git_repository.website.invalidate_access_token!
      false
    end
  end

  def branch
    super.present?  ? super
                    : 'main'
  end

  # TODO
  def files_in_the_repository
    super
  end

  protected

  def endpoint
    @endpoint.blank?  ? DEFAULT_ENDPOINT
                      : @endpoint
  end

  def client
    @client ||= Gitlab.client(
      endpoint: endpoint,
      private_token: access_token
    )
  end

  def find(path)
    client.get_file repository,
                    path,
                    branch
  rescue
    nil
  end

end
