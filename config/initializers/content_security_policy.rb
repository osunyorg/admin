# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do

  style_urls = %w(
    https://example.osuny.org/assets/css/
  )
  img_urls = %w()
  script_urls = %w(
    https://example.osuny.org/js/
    https://plausible.io
    https://d2wy8f7a9ursnm.cloudfront.net/v7/
  )
  script_urls << "https://cdn.jsdelivr.net/npm/summernote@#{SummernoteRails::Rails::VERSION.split('.').take(3).join('.')}/dist/lang/"
  
  font_urls = %w()
  media_urls = %w()
  frame_urls = %w()
  child_urls = %w()
  connect_urls = %w()
  form_action_urls = %w()

  defaults = %i[self https]

  config.content_security_policy do |policy|
    policy.base_uri    :none
    policy.default_src *defaults
    policy.font_src    *defaults, :data, *font_urls
    policy.img_src     *defaults, :data, *img_urls
    policy.media_src   *defaults, *media_urls
    policy.frame_src   *defaults, *frame_urls
    policy.child_src   *defaults, *child_urls
    policy.object_src  :none
    # We specify :unsafe_inline for browsers which not support nonce.
    # Unsafe eval is required for Vue scripts
    policy.script_src  :self, :unsafe_eval, *script_urls
    policy.style_src   :self, :unsafe_inline, *style_urls
    # If you are using webpack-dev-server then specify webpack-dev-server host
    # policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
    policy.connect_src *defaults, *connect_urls
    policy.form_action *defaults, *form_action_urls

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end


  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src)

  # Report violations without enforcing the policy.
  # config.content_security_policy_report_only = true
end
