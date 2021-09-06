class Github
  attr_reader :access_token, :repository

  def initialize(access_token, repository)
    @access_token = access_token
    @repository = repository
  end

  def publish(local_directory:, local_file:, data:, remote_file:, commit_message:)
    FileUtils.mkdir_p local_directory
    local_path = "#{local_directory}/#{ local_file }"
    File.write local_path, data
    begin
      content = client.content repository, path: remote_file
      sha = content[:sha]
    rescue
      sha = nil
    end
    client.create_contents  repository,
                            remote_file,
                            commit_message,
                            file: local_path,
                            sha: sha

  end

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end
end
