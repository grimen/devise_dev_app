#
# POSSIBLE IDEAS:
#
#   * Consider :type options, e.g. sign_in_link :user, :using => :facebook_connect
#

module DeviseHelper

  DEVISE_ACTIONS = {
      :sign_in => 'new_{{scope}}_session_path',
      :sign_out => 'destroy_{{scope}}_session_path',
      :sign_up => 'new_{{scope}}_path'
    }
  DEVISE_I18N_SCOPE = [:devise, :labels]
  DEVISE_I18N_SCOPES = [
      '{{scope}}.{{action}}',
      '{{action}}'
    ]

  # ----------------------------------------------------
  #  ACCOUNTS
  # ----------------------------------------------------

  # Helper: Link to sign up a new resource - based on a scope.
  #
  # == Examples:
  #
  #   = sign_up_link
  #   = sign_up_link :user
  #   = sign_up_link "Sign up now", :user, :js => true
  #   = sign_up_link do
  #     = image_tag('fancy_sign_up.png')
  #   end
  #
  def sign_up_link(*args, &block)
    devise_link_to(:sign_up, *args, &block)
  end

  # ----------------------------------------------------
  #  SESSIONS
  # ----------------------------------------------------

  # Helper: Link to sign in a resource - based on a scope.
  #
  # == Examples:
  #
  #   = sign_in_link
  #   = sign_in_link :user
  #   = sign_in_link "Sign in now", :user, :js => true
  #   = sign_in_link do
  #     = image_tag('fancy_sign_in.png')
  #   end
  #
  def sign_in_link(*args, &block)
    devise_link_to(:sign_in, *args, &block)
  end

  # Helper: Link to sign out a resource - based on a scope.
  #
  # == Examples:
  #
  #   = sign_out_link
  #   = sign_out_link :user
  #   = sign_out_link "Sign in now", :user, :js => true
  #   = sign_out_link do
  #     = image_tag('fancy_sign_out.png')
  #   end
  #
  def sign_out_link(*args, &block)
    devise_link_to(:sign_out, *args, &block)
  end

  # Helper: Auto-detect sign in/out link.
  #
  #   = sign_in_out_link
  #   = sign_in_out_link :user
  #   = sign_in_out_link :user, :js => true
  #
  # NOTE: Neither takes explicit string or block: Use +sign_in_link+/+sign_out_link+
  #       helpers if explicit label/content is needed - easier.
  #
  def sign_in_out_link(*args)
    args.reject! { |arg| arg.is_a?(String) } # Ignore strings.
    signed_in?(detect_devise_scope) ? sign_out_link(*args) : sign_in_link(*args)
  end

  # Re-usable helper to generate Devise view link helpers according to
  # certain convention/pattern, to make these easy to style and/or hook
  # with CSS and JavaScript straight out of the box.
  #
  # == Examples:
  #
  #   = devise_link_to :sign_in
  #   = devise_link_to :sign_in, :user
  #   = devise_link_to "Sign in now", :sign_in, :user, :js => true
  #   = devise_link_to :sign_in, :user do
  #     = image_tag('example.png')
  #   end
  #
  def devise_link_to(*args, &block)
    options = args.extract_options!
    unless action = args.detect { |arg| arg.is_a?(Symbol) && DEVISE_ACTIONS.keys.include?(arg) }
      raise "No action specified. Valid Devise actions: :sign_in, :sign_out, :sign_up"
    end
    scope = detect_devise_scope(*args)

    label_or_content = block_given? ? capture(&block) : args.detect { |arg| arg.is_a?(String) }
    label_or_content ||= devise_translate(action, scope)

    route = DEVISE_ACTIONS[action].gsub('{{scope}}', scope.to_s)
    attr_class = ['devise', "#{action}_link", scope, ('dialog' if options.delete(:js)), options[:class]].compact.join(' ')

    link_to(label_or_content, send(route), options.merge(:class => attr_class))
  end

  protected

    # Helper method to detect a valid Devise scope based on specified
    # value, or fallback on the default.
    #
    def detect_devise_scope(*args)
      unless scope = args.detect { |arg| arg.is_a?(Symbol) && !DEVISE_ACTIONS.keys.include?(arg) } || Warden::Manager.default_scope
        raise "No scope could be detected. Ensure that you got a authenticatable Devise model in you app."
      end
      scope
    end

    # Helper method to lookup labels based on specified Devise scope,
    # and type of action.
    #
    # == I18n lookup scopes:
    #
    #   1. devise.links.{{scope}}.{{action}}
    #   2. devise.links.{{action}}
    #
    # +{{action}}+ expects any of the values: "sign_in", "sign_out".
    # +{{scope}}+ expects any valid Devise scope, e.g. "user".
    #
    def devise_translate(action, scope, options = {})
      defaults = DEVISE_I18N_SCOPES.collect do |i18n_scope|
        i18n_key = i18n_scope.dup
        i18n_key.gsub!('{{action}}', action.to_s)
        i18n_key.gsub!('{{scope}}', scope.to_s)
        i18n_key.gsub!('..', '.')
        i18n_key.to_sym
      end
      defaults << action.to_s.humanize
      options.reverse_merge!(:scope => DEVISE_I18N_SCOPE)
      I18n.t(defaults.shift, options.merge(:default => defaults))
    end

end
