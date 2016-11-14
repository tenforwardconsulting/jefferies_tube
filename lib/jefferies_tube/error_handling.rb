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
      # boolean based on if there is a default layout for the current mime type
      layout = !!self.send(:_layout)
      #append_view_path File.expand_path(File.dirname(__FILE__), "../../app/views")
      render template: "/errors/#{code}", layout: layout, status: code

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

    def log_500
      if defined?(Rollbar)
        Rollbar.exception(@exception)
      end
    end

  end
end
