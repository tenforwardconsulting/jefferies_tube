class JefferiesTube::ErrorsController < ApplicationController
  before_action :disable_pundit
  skip_before_action :verify_authenticity_token

  def render_404
    log_404
    render_error_page 404
  end

  private
  def render_error_page(code)
    request.format = :html unless [:html, :json, :xml].include? request.format.to_sym
    respond_to do |format|
      format.any do
        begin
          render template: "/errors/#{code}", layout: has_app_layout?, status: code
        rescue #ActionView::MissingTemplate
          # Failsafe
          render template: "/errors/#{code}", layout: false, status: code
        end
      end
    end
  end

  def log_404
    if defined?(Rollbar) && request.referrer.present?
      Rollbar.warn("Got 404 with referrer", referrer: request.referrer, current_path: request.path)
    end
  end

  def disable_pundit
    if defined?(Pundit)
      skip_authorization
    end
  end

  def has_app_layout?
    !!resolve_layout([request.format.to_sym])
  end

  # Invokes the private `_layout` for the given formats. Its signature has
  # changed across Rails versions (`(formats, keys)` in 6.1–7,
  # `(lookup_context, formats, keys)` in 8+), so build the argument list by
  # matching the method's actual parameter names instead of hardcoding a count.
  def resolve_layout(formats)
    args = JefferiesTube::LayoutArgs.for(
      self.method(:_layout).parameters,
      lookup_context: lookup_context,
      formats: formats
    )
    self.send(:_layout, *args)
  end
end
