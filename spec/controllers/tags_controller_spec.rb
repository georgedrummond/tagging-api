require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe '#create' do
    context 'new success' do
      let!(:entity_type) { 'Product' }
      let!(:entity_identifier) { SecureRandom.uuid }
      let!(:tags) { ['Large', 'Pink', 'Bike'] }

      before do
        post :create, {
          entity_identifier: entity_identifier,
          entity_type: entity_type,
          tags: tags
        }
      end

      it { should respond_with :created }
      it { should render_template :show }

      describe 'created tagged_item' do
        let!(:tagged_item) do
          TaggedItem.find_by(entity_type: entity_type, entity_identifier: entity_identifier)
        end

        it 'has tags' do
          expect(tagged_item.tags.collect(&:name)).to eq tags
        end
      end
    end

    context 'already exists' do
      let!(:tagged_item) { create :tagged_item }
      let!(:new_tags)    { ['Small', 'Blue'] }

      before do
        tagged_item.assign_tags(*['Large', 'Pink'])
        post :create, {
          entity_identifier: tagged_item.entity_identifier,
          entity_type: tagged_item.entity_type,
          tags: new_tags
        }
      end

      it { should respond_with :created }
      it { should render_template :show }

      it 'should completely overwrite tags' do
        tags = tagged_item.reload.tags.collect(&:name)
        expect(tags).to eq new_tags
      end
    end

    context 'failure' do
      before do
        post :create, {
          entity_type: 'Blah'
        }
      end

      it { should respond_with :bad_request }
    end
  end

  describe '#show' do
    context 'success' do
      let!(:tagged_item) { create :tagged_item }

      before do
        tagged_item.assign_tags(*['Tag1', 'Tag2', 'Tag3'])
        get(
          :show,
          entity_type: tagged_item.entity_type,
          entity_identifier: tagged_item.entity_identifier,
        )
      end

      it { should respond_with :ok }
      it { should render_template :show }

      describe 'json' do
        subject do
          OpenStruct.new JSON.parse(response.body)
        end

        its(:id) { should eq tagged_item.id }
        its(:entity_type) { should eq tagged_item.entity_type }
        its(:entity_identifier) { should eq tagged_item.entity_identifier }
        its(:tags) { should eq ['Tag1', 'Tag2', 'Tag3'] }
      end
    end

    context 'not found' do
      before do
        get(
          :show,
          entity_type: 'Invalid',
          entity_identifier: 'Invalid',
        )
      end

      it { should respond_with :not_found }
    end
  end

  describe '#destroy' do
    context 'tagged_item exists' do
      let!(:tagged_item) { create :tagged_item }
      let!(:other_tagged_item) { create :tagged_item }

      let!(:tag_name) { 'Tag' }

      before do
        tagged_item.assign_tags(*[tag_name])
        other_tagged_item.assign_tags(*[tag_name])

        delete(
          :destroy,
          entity_type: tagged_item.entity_type,
          entity_identifier: tagged_item.entity_identifier,
        )
      end

      it { should respond_with :no_content }

      it 'should delete tagged_item' do
        expect(TaggedItem.all).to eq [other_tagged_item]
      end

      it 'should remove tag link to tagged_item' do
        tag = Tag.find_by(name: tag_name)
        expect(tag.tagged_items).to eq [other_tagged_item]
      end
    end

    context 'tagged_item doesnt exist' do
      before do
        delete(
          :destroy,
          entity_type: 'Invalid',
          entity_identifier: 'Invalid',
        )
      end

      it { should respond_with :not_found }
    end
  end
end
