module JefferiesTube
  VERSION = "0.1.6"

  def self.latest_rubygems_version
    JSON.parse(URI.parse("https://rubygems.org/api/v1/versions/jefferies_tube/latest.json").read)["version"]
  rescue
    nil
  end
end
