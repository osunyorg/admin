# Default structure to represent the git tree of a repository
# Override in your concrete provider implementation if key mapping is different
Git::Providers::Concerns::RestClient::TreeItem = Struct.new(:path, :sha, keyword_init: true) do
  def self.from_json(json)
    new(
      path: json['path'],
      sha: json['sha']
    )
  end
end