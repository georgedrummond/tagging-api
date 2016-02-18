require 'rails_helper'

RSpec.describe TaggedItem, type: :model do
  it { should have_and_belong_to_many :tags }

  it { should validate_presence_of :entity_type }
  it { should validate_presence_of :entity_identifier }
  it { should validate_uniqueness_of(:entity_identifier).scoped_to(:entity_type) }

  describe '#assign_tags' do
    let!(:tags) { ['Large', 'Pink', 'Bike'] }

    subject(:tagged_item) { create :tagged_item }

    before do
      tagged_item.assign_tags(*tags)
      tagged_item.reload
    end

    context 'no tags assigned' do
      its('tags.count') { should eq 3 }
      it 'assigns tags' do
        tag_names = tagged_item.tags.collect(&:name)
        expect(tag_names).to eq tags
      end
    end

    context 'tags already assigned' do
      let!(:new_tags) { ['Small', 'Orange', 'Shoe', 'New'] }

      before do
        tagged_item.assign_tags(*new_tags)
        tagged_item.reload
      end

      its('tags.count') { should eq 4 }
      it 'assigns tags' do
        tag_names = tagged_item.tags.collect(&:name)
        expect(tag_names).to eq new_tags
      end
    end
  end
end
