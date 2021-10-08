class ApplicationMailer < ActionMailer::Base
  # we have to specify the "from" and "reply_to" options for every mail
  layout 'mailer'

  def default_url_options
    {
      host: @university.host,
      port: Rails.env.development? ? 3000 : nil
    }
  end

  protected

  def merge_with_university_infos(university, opts)
    @university = university
    self.asset_host = university.url
    opts[:host] = university.host
    opts[:from] = opts[:reply_to] = university.mail_from[:full]
    opts
  end
end
