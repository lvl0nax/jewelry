# -*- coding: utf-8 -*-
class Card < ActiveRecord::Base

  STATUS = %w(в\ работе исполнен отклонён)

  belongs_to :user

end
