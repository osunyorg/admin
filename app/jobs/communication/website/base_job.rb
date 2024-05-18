class Communication::Website::BaseJob < ApplicationJob
  self.good_job_labels = ['website']

  queue_as :elephant

  attr_accessor :website_id

  def perform(website_id)
    @website_id = website_id
    # Website might be deleted in between
    return unless website.present?
    # TODO manage lock / unlock
    execute
  end

  protected

  def execute
    raise NotImplementedError 
  end

  def website
    @website ||= Communication::Website.find_by(id: website_id)
  end
end