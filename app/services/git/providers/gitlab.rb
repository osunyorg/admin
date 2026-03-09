class Git::Providers::Gitlab < Git::Providers::Abstract
  DEFAULT_ENDPOINT = 'https://gitlab.com/api/v4'.freeze
  COMMIT_BATCH_SIZE = 100

  def url
    base_url = endpoint.gsub("/api/v4", "")
    "#{base_url}/#{repository}"
  end

  def create_file(path, content)
    new_path_file = tree_item_at_path(path)
    action = new_path_file.nil? ? 'create' : 'update'

    batch << {
      action: action,
      file_path: path,
      content: content
    }
  end

  def update_file(path, previous_path, content)
    previous_path_file = tree_item_at_path(previous_path)
    new_path_file = tree_item_at_path(path)
    # En cas de dissonnance entre l'analyzer et le provider, on raise une erreur
    if previous_path_file.nil? && new_path_file.nil?
      raise "File to update does not exist on Git (repository: #{repository}, previous_path: #{previous_path}, path: #{path})"
    end

    if previous_path_file.present?
      if new_path_file.present?
        # We will remove file at previous path and update the one at new path
        batch << {
          action: 'delete',
          file_path: previous_path
        }
      else
        # We will move file at previous path and update it at new path
        batch << {
          action: 'move',
          file_path: path,
          previous_path: previous_path
        }
      end
    end

    batch << {
      action: 'update',
      file_path: path,
      content: content
    }
  end

  def destroy_file(path)
    file = tree_item_at_path(path)
    return if file.nil?
    batch << {
      action: 'delete',
      file_path: path
    }
  end

  def update_theme
    raise NoMethodError, "You must implement the `update_theme` method in #{self.class.name}"
  end

  def init_from_template(name)
    raise NoMethodError, "You must implement the `init_from_template` method in #{self.class.name}"
  end

  def update_secrets(secrets)
    raise NoMethodError, "You must implement the `update_secrets` method in #{self.class.name}"
  end

  def push(commit_message)
    byebug
    return if !valid? || batch.empty?
    client.create_commit  repository,
                          branch,
                          commit_message,
                          batch
    # The repo changed, invalidate the tree
    @tree = nil
    @tree_items_by_path = nil
    #
    true
  end

  def computed_sha(string)
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{string.bytesize}\x00#{string}"
  end

  # https://gitlab.com/gitlab-org/gitlab/-/issues/23504
  # TODO : Il faudrait, comme sur GitHub, stocker le tree pour éviter N requêtes pour N objets.
  def git_sha(path)
    return if path.nil?
    # Try to find in stored tree to avoid multiple queries
    tree_item_at_path(path)&.dig(:sha)
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
    super.presence || 'main'
  end

  def files_in_the_repository
    @files_in_the_repository ||= tree.map { |file| file[:path] }
  end

  protected

  def client
    @client ||= Gitlab.client(
      endpoint: endpoint,
      private_token: access_token
    )
  end

  def endpoint
    @endpoint.blank?  ? DEFAULT_ENDPOINT
                      : @endpoint
  end

  def find(path)
    client.get_file repository,
                    path,
                    branch
  rescue
    nil
  end

  def tree_item_at_path(path)
    tree_items_by_path[path] if tree_items_by_path.has_key? path
  end

  def tree_items_by_path
    unless @tree_items_by_path
      @tree_items_by_path = {}
      tree.each do |hash|
        path = hash["path"]
        @tree_items_by_path[path] = {
          mode: hash["mode"],
          type: hash["type"],
          sha: hash["id"]
        }
      end
    end
    @tree_items_by_path
  end

  def tree
    @tree ||= client.tree(repository, {
      ref: branch,
      recursive: true,
      per_page: 100
    }).auto_paginate
  end

end
