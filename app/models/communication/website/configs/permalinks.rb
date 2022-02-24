class Communication::Website::Configs::Permalinks < Communication::Website

  def self.polymorphic_name
    'Communication::Website::Configs::Permalinks'
  end

  def git_path(website)
    "config/_default/permalinks.yaml"
  end

end
