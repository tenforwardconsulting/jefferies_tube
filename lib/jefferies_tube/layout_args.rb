module JefferiesTube
  # Builds the positional argument list for ActionView's private `_layout`
  # method, whose signature has changed across Rails versions:
  #
  #   * 6.1–7.x:  _layout(formats, keys)
  #   * 8.0+:     _layout(lookup_context, formats, keys)
  #
  # Rather than hardcode a count (which breaks on every version we did not
  # anticipate), map the method's actual parameter names to the values we
  # have. Unknown parameter names fall back to `formats` so a future
  # signature change still receives the formats it expects.
  module LayoutArgs
    KNOWN = %i[lookup_context formats keys].freeze

    # @param parameters [Array] the result of `method(:_layout).parameters`
    # @param lookup_context the controller's lookup_context
    # @param formats [Array] e.g. [:html]
    # @return [Array] positional args to splat into `_layout`
    def self.for(parameters, lookup_context:, formats:)
      available = { lookup_context: lookup_context, formats: formats, keys: [] }
      parameters.map do |_type, name|
        available.fetch(name, formats)
      end
    end
  end
end
