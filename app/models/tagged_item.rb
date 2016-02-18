class TaggedItem < ActiveRecord::Base
  has_and_belongs_to_many :tags

  validates :entity_type, presence: true
  validates :entity_identifier, presence: true, uniqueness: { scope: :entity_type }

  def assign_tags(*tags)
    tags.map! do |name|
      Tag.find_or_create_by(name: name)
    end

    self.tags = tags
  end
end
