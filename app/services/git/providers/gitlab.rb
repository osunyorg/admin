class Git::Providers::Gitlab < Git::Providers::Abstract
  DEFAULT_ENDPOINT = 'https://gitlab.com/api/v4'

  def create_file(path, content)
    batch << {
      action: 'create',
      file_path: path,
      content: content
    }
  end

  def update_file(path, previous_path, content)
    file = find previous_path
    return if file.nil?
    if previous_path != path
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

  def push(commit_message)
    return if !valid? || batch.empty?
    client.create_commit  repository,
                          'main',
                          commit_message,
                          batch
    true
  end

  def computed_sha(string)
    OpenSSL::Digest::SHA256.hexdigest string
  end

  # https://gitlab.com/gitlab-org/gitlab/-/issues/23504
  def git_sha(path)
    begin
      file = find path
      sha = file['content_sha256']
    rescue
      sha = nil
    end
    sha
  end

  protected

  def endpoint
    @endpoint.blank?  ? DEFAULT_ENDPOINT
                      : @endpoint
  end

  def client
    @client ||= Gitlab.client(
      endpoint: endpoint,
      private_token: access_token
    )
  end

  def find(path)
    client.get_file repository,
                    path,
                    'main'
  rescue
    nil
  end

end
