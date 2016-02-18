class Tag < ActiveRecord::Base
  has_and_belongs_to_many :tagged_items

  validates :name, presence: true, uniqueness: true
end
