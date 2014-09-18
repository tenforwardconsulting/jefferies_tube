class JeffriesTube::AccessToken
  def self.create(hash)
    verifier.generate(hash.to_yaml)
  end

  def self.read(token)
    YAML.load(verifier.verify token)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    {}
  end

  private

  def self.verifier
    ActiveSupport::MessageVerifier.new(Rails.configuration.secret_token)
  end
end