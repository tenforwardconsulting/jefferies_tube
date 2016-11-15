module JefferiesTube
  module ErrorHandling
    extend ActiveSupport::Concern
    included do
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from Exception, with: :render_500
    end

    def render_404
      log_404
      render_error_page 404
    end

    def render_500(exception)
      if defined?(Rollbar)
        @rollbar = Rollbar.error(exception)
      end
      @exception = exception
      render_error_page(500)
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
      if Gem::Version.new(::Rails.version) >= Gem::Version.new("5")
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
end
