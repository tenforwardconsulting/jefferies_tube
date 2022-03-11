class JefferiesTube::Console
  def self.prompt_base
    rails_env = JefferiesTube.configuration.environment
    if rails_env
      color = "\e[0m" #Default to white text on no background
      current_app = JefferiesTube.configuration.prompt_name

      if rails_env == "development"
      elsif rails_env == "dev"
        color = "\e[0;37m\e[1;44m" #White on blue
      elsif ["test", "qa", "staging"].include? rails_env
        color = "\e[0;37m\e[1;43m" #White on yellow
      elsif rails_env == "production"
        color = "\e[0;37m\e[1;41m" #White on red
      end

      base = "#{color}#{current_app}(#{rails_env})\e[0m"
      return "#{base}"
    else
      return "#{current_app}"
    end
  end

  def self.pry_prompts
    [
      # wait_proc
      proc { prompt_base + " > " },
      # incomplete_proc
      proc { prompt_base + "*> "}
    ]
  end
end
