# # Be sure to restart your server when you modify this file.

# # Define an application-wide content security policy.
# # See the Securing Rails Applications Guide for more information:
# # https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, :https
#     policy.font_src    :self, :https, :data
#     policy.img_src     :self, :https, :data
#     policy.object_src  :none
#     policy.media_src  :none
#     policy.child_src  :none
#     policy.script_src  :self, :https
#     # , :unsafe_inline
#     policy.style_src   :self, :https
#     # policy.style_src   :self, :https, 'unsafe-inline'
#     # Specify URI for violation reports
#     policy.connect_src :self, :https, "http://10.50.55.90:3000", "ws://10.50.55.90:3000" if Rails.env.development?
#     policy.frame_ancestors :none
#       # policy.report_uri "/csp-violation-report-endpoint"
#   end

#   # Generate session nonces for permitted importmap and inline scripts
#   # config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }
#   # based on suggestion https://github.com/hotwired/turbo/issues/294#issuecomment-877842232
#   # config.content_security_policy_nonce_generator = -> (request) do
#   #   # use the same csp nonce for turbo requests
#   #   if request.env['HTTP_TURBO_REFERRER'].present?
#   #     request.env['HTTP_X_TURBO_NONCE']
#   #   else
#   #     SecureRandom.base64(16)
#   #   end
#   # end
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src style-src)

#   # Report violations without enforcing the policy.
#   # config.content_security_policy_report_only = true
# end
