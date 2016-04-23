class JefferiesTube::ErrorsController < ApplicationController
  before_filter :disable_pundit

  def render_404
    render_error_page 404
  end

  def render_500
    render_error_page 500
  end

  private
  def render_error_page(code)
    # boolean based on if there is a default layout for the current mime type
    layout = !!self.send(:_layout)
    log_404
    begin
      render template: "/errors/#{code}", layout: layout, status: code
    rescue ActionView::MissingTemplate
      render "render_#{code}".to_sym, layout: layout, status: code
    end
  end

  def disable_pundit
    if defined?(Pundit)
      skip_authorization
    end
  end

  def log_404
    if defined?(Rollbar) && request.referrer.present?
      Rollbar.warn("Got 404 with referrer", referrer: request.referrer, current_path: request.path)
    end
  end
end
