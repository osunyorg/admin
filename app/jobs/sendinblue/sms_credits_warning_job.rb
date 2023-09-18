class Sendinblue::SmsCreditsWarningJob < ApplicationJob
  queue_as :default

  SMS_CREDITS_LIMIT = 500

  def perform
    return unless ENV['APPLICATION_ENV'] == 'production'
    api_instance = SibApiV3Sdk::AccountApi.new
    result = api_instance.get_account
    sms_credits = result.plan.detect { |plan| plan.type == 'sms' }&.credits
    if sms_credits.present? && sms_credits < SMS_CREDITS_LIMIT
      # this message is sent to server_admins only, and server_admins are duplicated between all universities.
      # so we take the first university
      NotificationMailer.low_sms_credits(University.first, sms_credits).deliver_later
    end
  end
end