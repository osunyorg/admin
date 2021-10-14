class DeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, opts={})
    opts = merge_with_university_infos(record.university, opts)
    I18n.with_locale(record.language.iso_code.to_sym) do
      super
    end
  end

  def reset_password_instructions(record, token, opts={})
    opts = merge_with_university_infos(record.university, opts)
    I18n.with_locale(record.language.iso_code.to_sym) do
      super
    end
  end

  def unlock_instructions(record, token, opts={})
    opts = merge_with_university_infos(record.university, opts)
    I18n.with_locale(record.language.iso_code.to_sym) do
      super
    end
  end

  def email_changed(record, opts={})
    opts = merge_with_university_infos(record.university, opts)
    I18n.with_locale(record.language.iso_code.to_sym) do
      super
    end
  end

  def password_change(record, opts={})
    opts = merge_with_university_infos(record.university, opts)
    I18n.with_locale(record.language.iso_code.to_sym) do
      super
    end
  end

  def two_factor_authentication_code(record, code, opts = {})
    opts = merge_with_university_infos(record.university, opts)
    @code = code
    I18n.with_locale(record.language.iso_code.to_sym) do
      devise_mail(record, :two_factor_authentication_code, opts)
    end
  end

  def default_url_options
    {
      host: @university.host,
      port: Rails.env.development? ? 3000 : nil
    }
  end

  private

  def merge_with_university_infos(university, opts)
    @university = university
    opts[:host] = university.host
    opts[:from] = opts[:reply_to] = university.mail_from[:full]
    opts
  end

end
