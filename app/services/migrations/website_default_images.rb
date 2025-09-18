class Migrations::WebsiteDefaultImages
  ATTACHMENT_NAMES = ["default_image", "default_shared_image"].freeze

  def self.migrate
    ATTACHMENT_NAMES.each do |attachment_name|
      migrate_attachment_name attachment_name
    end
  end

  protected

  def self.migrate_attachment_name(attachment_name)
    ActiveStorage::Attachment.where(
      name: attachment_name,
      record_type: "Communication::Website"
    ).each do |attachment|
      migrate_attachment attachment
    end
  end

  def self.migrate_attachment(attachment)
    website = attachment.record
    website.localizations.each do |website_l10n|
      find_or_create_l10n_attachment(website_l10n, attachment)
    end
  end

  def self.find_or_create_l10n_attachment(website_l10n, website_attachment)
    ActiveStorage::Attachment.where(
      name: website_attachment.name,
      record: website_l10n
    ).first_or_create do |new_attachment|
      new_attachment.blob_id = website_attachment.blob_id
    end
  end
end
