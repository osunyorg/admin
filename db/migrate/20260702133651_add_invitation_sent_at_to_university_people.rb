class AddInvitationSentAtToUniversityPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :university_people, :invitation_sent_at, :datetime
  end
end
