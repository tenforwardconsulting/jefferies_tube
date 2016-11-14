class JefferiesTube::ErrorsController < ApplicationController
  before_filter :disable_pundit
  skip_before_filter :verify_authenticity_token

  def render_404
    log_404
    render_error_page 404
  end

  def additional_information
    # TODO not implemented yet
    render text: "Thanks!", layout: app_layout
  end

  private
  def render_error_page(code)
    begin
      render template: "/errors/#{code}", layout: app_layout, status: code
    rescue ActionView::MissingTemplate
      render "render_#{code}".to_sym, layout: app_layout, status: code
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

  def app_layout
    if Gem::Version.new(Rails.version) >= Gem::Version.new("5")
      !!self.send(:_layout, [params[:format]])
    else
      # boolean based on if there is a default layout for the current mime type
      !!self.send(:_layout)
    end
  end

end
