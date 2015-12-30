class Category < ActiveRecord::Base
  validates :name, presence: true, length: {in: 4..16}
end
