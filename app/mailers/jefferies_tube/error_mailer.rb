class JefferiesTube::ErrorMailer < ActionMailer::Base
  def new_comments(meta)
    mail({
      to: "brian@tenforwardconsulting.com",
      from: "jefferies@tube.com",
      subject: 'New comments on an error',
      body: meta
    })
  end
end
