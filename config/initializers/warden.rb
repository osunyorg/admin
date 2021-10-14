Warden::Manager.prepend_after_authentication do |user, auth, options|
  I18n.locale = user.language.iso_code.to_sym
end