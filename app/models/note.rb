class Note < ActiveRecord::Base
  belongs_to :songs

  attr_accessible :link
end