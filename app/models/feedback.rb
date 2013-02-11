class Feedback < ActiveRecord::Base
   attr_accessible :name, :location, :body
   attr_accessor :check_code

  validates :name, :location, :body, presence: true,
                                    :format => { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }
  validates :check_code, presence: true
  validate :check_code_is_not_current_year, :on => :create

  scope :published, where( :is_published => true )

private
  def check_code_is_not_current_year
    unless check_code.to_s == Date.today.strftime("%Y") # to_s need to be?
      errors.add(:check_code, 'is not current year')
    end
  end

end