class Sendinblue::SmsCreditsWarningJob < ApplicationJob
  queue_as :default

  def perform
    return unless ENV['APPLICATION_ENV'] == 'production'
    if Sendinblue.SmsService.low?
      # this message is sent to server_admins only, and server_admins are duplicated between all universities.
      # so we take the first university
      NotificationMailer.low_sms_credits(University.first, sms_credits).deliver_later
    end
  end
end