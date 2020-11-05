require_relative '../lib/jefferies_tube'

RSpec.describe "Configuration" do
  describe 'configuration' do
    it 'allows the Environment name to be initialized' do
      expect(JefferiesTube.configuration.environment).to_not be_nil
    end

    it 'allows a custom environment name & prompt' do
      JefferiesTube.configure do |config|
        config.environment = 'production' # If you're using a nonstandard env name but want colors.
        config.prompt_name = 'ShortName' #For a shorter prompt name if you have a long app
      end

      expect(JefferiesTube.configuration.environment).to eq("production")
      expect(JefferiesTube.configuration.prompt_name).to eq("ShortName")
    end

  end
end
