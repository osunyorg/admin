module User::WithBrevo
  extend ActiveSupport::Concern

  included do
    attr_accessor :from_brevo_webhook
    after_commit :sync_with_brevo, on: [:create, :update], if: :should_sync_with_brevo?
    after_commit :destroy_from_brevo, on: :destroy
  end

  private

  def sync_with_brevo
    Brevo::UserSyncJob.perform_later(self)
  end

  def destroy_from_brevo
    Brevo::UserDestroyJob.perform_later(self.brevo_contact_id) if self.brevo_contact_id.present?
  end

  def after_confirmation
    sync_with_brevo
  end

  def should_sync_with_brevo?
    return false unless confirmed?
    # Saved from Brevo webhook, no need to call it
    return false if from_brevo_webhook

    saved_change_to_optin_newsletter? ||
    saved_change_to_email? ||
    saved_change_to_first_name? ||
    saved_change_to_last_name?
  end

end
