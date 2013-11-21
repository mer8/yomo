class NotificationsMailer< ActionMailer::Base
 
  default :from => "noreply@yomo.la"
  # default :to => "you@youremail.dev"
 
  def new_message(message)
    @message = message
    mail(:subject => "#{message.subject}", :to => message.email)
  end
 
end
