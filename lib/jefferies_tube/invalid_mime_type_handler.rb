class JefferiesTube::InvalidMimeTypeHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ::ActionDispatch::Http::MimeNegotiation::InvalidType
    Rails.logger.info("Invalid MIME type in request: #{env['HTTP_ACCEPT']}")
    
    [406, { 'Content-Type' => 'text/plain' }, ['Invalid Accept header.']]
  end
end
