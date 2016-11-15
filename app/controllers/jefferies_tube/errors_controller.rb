class JefferiesTube::ErrorsController < ApplicationController
  before_filter :disable_pundit
  skip_before_filter :verify_authenticity_token

  def render_404
    log_404
    render_error_page 404
  end

  def fail
    raise "Barf"
  end

  def additional_information
    if defined?(Rollbar)
      uri = URI.parse("https://rollbar.com/instance/uuid/?uuid=#{params[:rollbar_uuid]}")
      response = Net::HTTP.get_response(uri)
      if response.code == "302" && response["Location"] =~ /items\/(\d+)\/occurrences\/(\d+)\//
        item_id, occurrence_id = $1, $2
        ErrorMailer.new_comments(comments: params[:comments], url: response["Location"]).deliver_now!
      end
    end
    render html: "<p>Thanks for the feedback, and we apologize for the inconvenience.</p>", layout: has_app_layout?
  end

  private
  def render_error_page(code)
    request.format = :html unless [:html, :json, :xml].include? request.format.to_sym
    begin
      render template: "/errors/#{code}", layout: has_app_layout?, status: code
    rescue ActionView::MissingTemplate
      # Failsafe
      render template: "/errors/#{code}", layout: html_layout, status: code, formats: [:html]
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
      !!self.send(:_layout, [request.format.to_sym])
    else
      # boolean based on if there is a default layout for the current mime type
      !!self.send(:_layout)
    end
  end

  def html_layout
    if Gem::Version.new(Rails.version) >= Gem::Version.new("5")
      self.send(:_layout, ["html"]).virtual_path
    else
      # boolean based on if there is a default layout for the current mime type
      "application"
    end
  end
end
