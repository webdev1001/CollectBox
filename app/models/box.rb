class Box < ActiveRecord::Base
  validates :name, presence: true

  def folder_name
    name.parameterize
  end
end
