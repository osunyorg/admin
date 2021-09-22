# == Schema Information
#
# Table name: research_researchers
#
#  id         :uuid             not null, primary key
#  biography  :text
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_research_researchers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Research::Researcher < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :articles, class_name: 'Research::Journal::Article'
  has_many :journals, through: :articles

  after_save :publish_to_github

  def websites
    @websites ||= journals.collect(&:website).uniq.compact
  end

  def publish_to_website(website)
    github = Github.new website.access_token, website.repository
    github.publish  kind: :authors,
                    file: "#{ id }.md",
                    title: to_s,
                    data: ApplicationController.render(
                      template: 'admin/research/researchers/jekyll',
                      layout: false,
                      assigns: { researcher: self }
                    )
  end

  def to_s
    "#{ first_name } #{ last_name }"
  end

  protected

  def publish_to_github
    websites.each { |website| publish_to_website(website) }
  end
end
