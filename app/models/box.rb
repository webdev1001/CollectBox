class Box < ActiveRecord::Base
  validates :name, presence: true
end
