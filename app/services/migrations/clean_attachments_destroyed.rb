class Migrations::CleanAttachmentsDestroyed

  def self.migrate
    puts 'Migrations::CleanAttachmentsDestroyed.migrate'
    ActiveStorage::Attachment.only_deleted.find_each do |attachment|
      next if attachment.record.nil? || 
              attachment.record.is_a?(Communication::Website::GitFile) || 
              !attachment.record.respond_to?(:deleted?) ||
              !attachment.record.deleted?
      puts attachment.record.to_gid.to_s
      attachment.really_destroy!
    end
  end
end