module Communication::Website::WithGitRepositoryLock
  extend ActiveSupport::Concern

  included do
    belongs_to  :synchronization_locked_by,
                class_name: 'User',
                optional: true
  end

  def manage_sync(active, user)
    if active && synchronization_locked?
      unlock_synchronization!
    elsif !active && synchronization_active
      lock_synchronization!(user)
    end
  end

  def synchronization_active
    !synchronization_locked?
  end

  def synchronization_locked?
    synchronization_locked_by_id.present?
  end

  def lock_synchronization!(user)
    update_column :synchronization_locked_by_id, user.id
  end

  def unlock_synchronization!
    update_column :synchronization_locked_by_id, nil
    sync_with_git if desynchronized_generated_git_files.any?
  end

end
