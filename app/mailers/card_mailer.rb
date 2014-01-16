# -*- encoding : utf-8 -*-
class CardMailer < ActionMailer::Base
  default from: 'bujua'
  def new_order_mail(options)
    @card = options
    emails = 'lvl0nax@gmail.com'
    # emails = "9856544@gmail.com,akvapolus@restsguide.ru,lider-aqva@metropost.ru"
    mail to: emails, subject: 'Сайт: новый заказ'
  end
end
