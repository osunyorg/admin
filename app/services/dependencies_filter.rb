class DependenciesFilter

  # [
  #   "gid://osuny/Communication::Block/4ac9f6fe-80cd-46f6-becc-fc14b3fecea0",
  #   "gid://osuny/University::Person/36501bf0-99b9-58f9-b269-bf161b451c43"
  # ]
  def self.filtered(dependencies)
    dependencies.select { |dependency| dependency.is_a?(ActiveRecord::Base) }
                .map    { |dependency| dependency.to_global_id.to_s }
                .uniq
  end
end