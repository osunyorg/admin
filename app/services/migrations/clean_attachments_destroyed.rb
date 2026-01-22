class Migrations::CleanAttachmentsDestroyed

  def self.migrate
    puts 'Migrations::CleanAttachmentsDestroyed.migrate'
    ActiveStorage::Attachment.only_deleted.find_each do |attachment|
      next if should_keep(attachment)
      puts "Destroy attachment #{attachment.name} for #{attachment.record_type}/#{attachment.record_id}"
      attachment.really_destroy!
    end
  end

  # For every soft-deleted attachment
  # - paranoia (0) : destroy
  # - paranoia (1)
  #   - alive : destroy (c'est le cas actuel)
  #   - soft-deleted : keep (c'est le cas corbeille)
  #   - hard-deleted : destroy (en cas de fail de chaîne de really_destroy)
  def self.should_keep(attachment)
    return false if !attachment.record_type.constantize.paranoid?
    record_scope = attachment.record_type.constantize.with_deleted
    record = record_scope.find(attachment.record_id)
    return false if record.nil? # hard-deleted
    return false if record.deleted_at.nil? # alive
    puts "will keep attachment #{attachment.name} for #{record.to_gid.to_s} (deleted_at: #{record.deleted_at})"
    true # soft-deleted
  end
end