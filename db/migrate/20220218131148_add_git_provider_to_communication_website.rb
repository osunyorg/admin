class AddGitProviderToCommunicationWebsite < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :git_provider, :integer, default: 0
  end
end
