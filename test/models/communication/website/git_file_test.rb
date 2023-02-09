# == Schema Information
#
# Table name: communication_website_git_files
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  previous_path :string
#  previous_sha  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_git_files_on_website_id  (website_id)
#  index_communication_website_github_files_on_about    (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_8505d649e8  (website_id => communication_websites.id)
#
require "test_helper"

class Communication::Website::GitFileTest < ActiveSupport::TestCase
  test "should_create? a new file" do
    VCR.use_cassette(location) do
      file = communication_website_git_files(:git_file_1)
      analyzer = Git::Analyzer.new(file.website.git_repository)
      analyzer.git_file = file
      assert analyzer.should_create?
    end
  end

  test "should_update? an existing file" do
    VCR.use_cassette(location) do
      # To create the file, i first did that:
      # file = communication_website_git_files(:git_file_2)
      # file.website.git_repository.add_git_file file
      # file.website.git_repository.sync!
      # Then i got the sha and path, pasted it in the fixtures,
      # changed the text so the content would need an update.
      file = communication_website_git_files(:git_file_2)
      analyzer = Git::Analyzer.new(file.website.git_repository)
      analyzer.git_file = file
      assert analyzer.should_update?
    end
  end
end
