class RegistrationsMailer < ApplicationMailer
    default from: ENV["SMTP_USER"]

    layout "mailer"
  
    def notify(recipient=nil, new_user)
      @new_user = new_user
      @recipient = recipient
      mail(
        to: recipient.email, 
        subject: "New user registered for TerraLing",
        date: Time.now,
        content_type: "text/html",
        template_path: "mailers",
        template_name: "notify"
      )
    end
  end