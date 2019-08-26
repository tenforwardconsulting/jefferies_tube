rails_env = JefferiesTube.configuration.environment

if rails_env
  color = "\e[0m" #Default to white text on no background
  current_app = JefferiesTube.configuration.prompt_name

  # shorten some common long environment names
  if ["development", "dev"].include? rails_env
    rails_env = "dev"
    color = "\e[0;37m\e[1;44m" #White on blue
  elsif ["test", "qa", "staging"].include? rails_env
    color = "\e[0;37m\e[1;43m" #White on yellow
  elsif rails_env == "production"
    rails_env = "prod"
    color = "\e[0;37m\e[1;41m" #White on red
  end 

  base = "#{color}#{current_app}(#{rails_env})\e[0m"
  prompt = base + "> "

  IRB.conf[:PROMPT][:RAILS_ENV] = {   
      :PROMPT_I => prompt,
      :PROMPT_N => prompt,
      :PROMPT_S => nil,
      :PROMPT_C => base + ">* ",
      :RETURN => "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :RAILS_ENV

end
