class JefferiesTube::InvaildRequestHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ::ActionDispatch::Http::MimeNegotiation::InvalidType
    Rails.logger.info("[JefferiesTube::InvaildRequestHandler] Rescued from invalid MIME type in request: #{env['HTTP_ACCEPT']}")
    
    [406, { 'Content-Type' => 'text/plain' }, ['Invalid Accept header.']]
  rescue ArgumentError => error
    if error.message =~ /invalid byte sequence in UTF-8/
      return rescue_from_error(error, 'Bad request: Invalid UTF-8 sequence')
    elsif error.message =~ /invalid %-encoding/ # support for rails < 8
      return rescue_from_error(error, 'Bad request: invalid %-encoding')
    end

    raise error
  rescue ActionController::BadRequest => error
    if error.message =~ /invalid %-encoding/
      return rescue_from_error(error, 'Bad request: invalid %-encoding')
    elsif error.message =~ /Invalid encoding for parameter/
      return rescue_from_error(error, 'Bad request: Invalid encoding for parameter')
    end

    raise error
  end

  def rescue_from_error(error, message)
    Rails.logger.info("[JefferiesTube::InvaildRequestHandler] Rescued from #{error.message.inspect}")

    [400, { 'Content-Type' => 'text/plain' }, [message]]
  end
end
