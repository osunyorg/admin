class CreateJoinTableCommunicationWebsitesUniversityOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_join_table :communication_websites, :university_organizations, column_options: {type: :uuid} do |t|
      t.index [:communication_website_id, :university_organization_id], name: 'website_organization'
      t.index [:university_organization_id, :communication_website_id], name: 'organization_website'
    end
  end
end
