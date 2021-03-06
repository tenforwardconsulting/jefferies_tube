class JefferiesTube::Console
  def self.prompt
    rails_env = JefferiesTube.configuration.environment
    if rails_env
      color = "\e[0m" #Default to white text on no background
      current_app = JefferiesTube.configuration.prompt_name

      # shorten some common long environment names
      if rails_env == "development"
      elsif rails_env == "dev"
        rails_env = "dev"
        color = "\e[0;37m\e[1;44m" #White on blue
      elsif ["test", "qa", "staging"].include? rails_env
        color = "\e[0;37m\e[1;43m" #White on yellow
      elsif rails_env == "production"
        rails_env = "prod"
        color = "\e[0;37m\e[1;41m" #White on red
      end

      base = "#{color}#{current_app}(#{rails_env})\e[0m"
      return "#{base}> "
    else
      return "#{current_app}> "
    end
  end
end
