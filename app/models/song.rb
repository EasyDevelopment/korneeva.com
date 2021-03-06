# encoding: UTF-8
class Song < ActiveRecord::Base
  attr_accessible :title, :authors, :record_year, :lyrics, :music_papers

  validates :title, :authors, :lyrics,
            presence: true,
            :format => { :with => /\A[a-zA-Z\sА-Яа-я\.\,\!\?-]+\z/,
              :message => "Можно вводить только буквы и знаки препинания" }
end
