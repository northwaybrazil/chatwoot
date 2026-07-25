class AdministratorNotifications::ChannelNotificationsMailer < AdministratorNotifications::BaseMailer
  def facebook_disconnect(inbox)
    subject = 'Sua conexão com a página do Facebook expirou'
    send_notification(subject, action_url: inbox_url(inbox))
  end

  def instagram_disconnect(inbox)
    subject = 'Sua conexão com o Instagram expirou'
    send_notification(subject, action_url: inbox_url(inbox))
  end

  def tiktok_disconnect(inbox)
    subject = 'Sua conexão com o TikTok expirou'
    send_notification(subject, action_url: inbox_url(inbox))
  end

  def whatsapp_disconnect(inbox)
    subject = 'Sua conexão com o WhatsApp expirou'
    send_notification(subject, action_url: inbox_url(inbox))
  end

  def email_disconnect(inbox)
    subject = 'Sua caixa de entrada de e-mail foi desconectada. Atualize as credenciais de SMTP/IMAP'
    send_notification(subject, action_url: inbox_url(inbox))
  end
end
