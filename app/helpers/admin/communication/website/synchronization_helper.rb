module Admin::Communication::Website::SynchronizationHelper

  def synchronization_locked_by_label(user)
    if user.server_admin?
      role = t('activerecord.attributes.user.roles.server_admin').downcase
      t('admin.communication.website.synchronization_locked_by_role', role: role)
    else
      t('admin.communication.website.synchronization_locked_by', user: user)
    end
  end
  
end
