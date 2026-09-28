# == Schema Information
#
# Table name: university_file_servers
#
#  id            :uuid             not null, primary key
#  ftp_host      :string
#  ftp_password  :string
#  ftp_path      :string
#  ftp_port      :integer
#  ftp_username  :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             uniquely indexed
#
# Indexes
#
#  index_university_file_servers_on_university_id  (university_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_2bd65e6c37  (university_id => universities.id)
#
class University::FileServer < ApplicationRecord
  belongs_to :university

  def correct?
    ftp_host.present? &&
    ftp_port.present? &&
    ftp_username.present? &&
    ftp_password.present?
  end
end
