prompt = JefferiesTube::Console.prompt

IRB.conf[:PROMPT][:RAILS_ENV] = {
    :PROMPT_I => prompt,
    :PROMPT_N => prompt,
    :PROMPT_S => nil,
    :PROMPT_C => prompt.sub('> ', '>* '),
    :RETURN => "=> %s\n"
}

IRB.conf[:PROMPT_MODE] = :RAILS_ENV
