class Git::Providers::Gitlab < Git::Providers::Abstract
  DEFAULT_ENDPOINT = 'https://gitlab.com/api/v4'.freeze
  COMMIT_BATCH_SIZE = 75

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
    previous_file = find previous_path
    file = find path
    action = file.present? ? 'update' : 'create'
    if previous_file.present? && previous_path != path
      batch << {
        action: 'delete',
        file_path: previous_path
      }
    end
    batch << {
      action: action,
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

  def update_theme!
    return unless should_update_theme?
    client.edit_submodule repository,
                          ENV["GITHUB_WEBSITE_THEME_PATH"],
                          {
                            branch: branch,
                            commit_sha: current_theme_sha,
                            commit_message: theme_update_commit_message
                          }
  end

  def init_from_template(name)
    raise NoMethodError, "You must implement the `init_from_template` method in #{self.class.name}"
  end

  def update_secrets(secrets)
    raise NoMethodError, "You must implement the `update_secrets` method in #{self.class.name}"
  end

  def push(commit_message)
    return if !valid? || batch.empty?
    check_batch_integrity!
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

  def check_batch_integrity!
    # Delete files first
    batch.sort_by! { |item| item[:action] == 'delete' ? 0 : 1 }
    # Use files states to fix actions
    batch.each do |item|
      check_batch_item_integrity!(item)
    end
    # Reject
    batch.reject! { |item| item[:action].nil? }
  end

  def check_batch_item_integrity!(item)
    action = item[:action]
    path = item[:file_path]
    current_state = files_states[path]
    target_state = action == 'delete' ? 'DELETED' : 'EXISTS'

    if action == 'delete' && current_state == 'DELETED'
      # No need to delete an already deleted file => skip action
      item[:action] = nil
    elsif action == 'update' && current_state == 'DELETED'
      # Can't update a deleted file => should create
      item[:action] = 'create'
    elsif action == 'create' && current_state == 'EXISTS'
      # Can't create an existing file => should update
      item[:action] = 'update'
    end
    files_states[path] = target_state
  end

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
