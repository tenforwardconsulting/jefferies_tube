require 'open-uri'

module JefferiesTube
  VERSION = "1.7.2"

  def self.latest_rubygems_version
    JSON.parse(URI.parse("https://rubygems.org/api/v1/versions/jefferies_tube/latest.json").read)["version"]
  rescue
    nil
  end
end
