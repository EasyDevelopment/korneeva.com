class Song < ActiveRecord::Base
  attr_accessible :title, :authors, :record_year, :lyrics

  has_many :notes

  validates :title, :authors, :lyrics, presence: true

end
