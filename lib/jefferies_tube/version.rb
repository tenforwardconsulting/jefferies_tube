module JefferiesTube
  VERSION = "0.1.3"

  def self.latest_rubygems_version
    JSON.parse(Net::HTTP.get('rubygems.org', '/api/v1/versions/jefferies_tube/latest.json'))["version"]
  rescue
    nil
  end
end
