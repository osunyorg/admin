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
  test "github should_create?" do
    file = communication_website_git_files(:git_file_1)
    # This is wrong! Fixtures must be prepared properly
    assert_not file.should_create?
  end

  test "github correct sha" do
    file = communication_website_git_files(:git_file_1)
    assert_equal file.sha, '5d387e7e2da68026aeb0cfc2e6a67f509a3e1ff6'
  end
end
