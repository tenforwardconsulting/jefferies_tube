prompt = JefferiesTube::Console.prompt_base

IRB.conf[:PROMPT][:JEFFERIES_TUBE] = {
  :PROMPT_I => "#{prompt} > ",
  :PROMPT_N => "#{prompt}%l> ",
  :PROMPT_S => "#{prompt}%l> ",
  :PROMPT_C => "#{prompt}*> ",
  :RETURN => "  => %s\n"
}

if ENV["JEFFERIES_TUBE_IRB"]
  IRB.conf[:USE_MULTILINE] = false
  IRB.conf[:USE_AUTOCOMPLETE] = false
  IRB.conf[:PROMPT_MODE] = :JEFFERIES_TUBE
end
