class JefferiesTube::ErrorsController < ApplicationController
  if Rails.version.start_with? "3"
    before_filter :disable_pundit
    skip_before_filter :verify_authenticity_token
  else
    before_action :disable_pundit
    skip_before_action :verify_authenticity_token
  end

  def render_404
    log_404
    render_error_page 404
  end

  def additional_information
    # TODO not implemented yet
    render text: "Thanks!", layout: has_app_layout?
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
    if Gem::Version.new(Rails.version) >= Gem::Version.new("5")
      !!self.send(:_layout, lookup_context, [request.format.to_sym])
    else
      # boolean based on if there is a default layout for the current mime type
      !!self.send(:_layout, lookup_context)
    end
  end

  def html_layout
    if Gem::Version.new(Rails.version) >= Gem::Version.new("5")
      self.send(:_layout,, lookup_context, ["html"]).virtual_path
    else
      # boolean based on if there is a default layout for the current mime type
      "application"
    end
  end
end
