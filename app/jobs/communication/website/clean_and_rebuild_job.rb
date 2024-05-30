class Communication::Website::CleanAndRebuildJob < Communication::Website::BaseJob
  queue_as :whale

  def perform(website_id, options = {})
    # Clean and Rebuild Job is a special job that can be run even if the website is locked
    super(website_id, options.merge(skip_website_lock: true))
  end

  def execute
    website.clean_and_rebuild
  end
end