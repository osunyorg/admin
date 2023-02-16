class RemoveJoinTableCommunicationWebsitesUniversityOrganizations < ActiveRecord::Migration[7.0]
  def change
    drop_table :communication_websites_university_organizations
  end
end
