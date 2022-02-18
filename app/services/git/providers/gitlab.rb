class Git::Providers::Gitlab < Git::Providers::Abstract
  def create_file(path, content)
  end

  def update_file(path, previous_path, content)
  end

  def destroy_file(path)
  end

  def push(commit_message)
  end

  def git_sha(path)
  end
end
