require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  let!(:tag_1) { Faker::Lorem.word }
  let!(:tag_2) { Faker::Lorem.word }
  let!(:tag_3) { Faker::Lorem.word }
  let!(:tag_4) { Faker::Lorem.word }

  let!(:tagged_item_1) { create :tagged_item }
  let!(:tagged_item_2) { create :tagged_item }
  let!(:tagged_item_3) { create :tagged_item }
  let!(:tagged_item_4) { create :tagged_item }

  before do
    tagged_item_1.assign_tags(*[tag_4])
    tagged_item_2.assign_tags(*[tag_4, tag_3])
    tagged_item_3.assign_tags(*[tag_4, tag_3, tag_2])
    tagged_item_4.assign_tags(*[tag_4, tag_3, tag_2, tag_1])
  end

  describe '#index' do
    before { get :index }

    it { should respond_with :ok }
    it { should render_template :index }

    describe 'json returned' do
      let!(:json) do
        JSON.parse(response.body)
      end

      it 'counts 4 for tag 4' do
        expect(json.find {|t| t['name'] == tag_4}['count']).to eq 4
      end

      it 'counts 3 for tag 3' do
        expect(json.find {|t| t['name'] == tag_3}['count']).to eq 3
      end

      it 'counts 2 for tag 2' do
        expect(json.find {|t| t['name'] == tag_2}['count']).to eq 2
      end

      it 'counts 1 for tag 1' do
        expect(json.find {|t| t['name'] == tag_1}['count']).to eq 1
      end
    end
  end

  describe '#show' do
    before do
      get(
        :show,
        entity_type: tagged_item_3.entity_type,
        entity_identifier: tagged_item_3.entity_identifier
      )
    end

    it { should respond_with :ok }
    it { should render_template :show }

    describe 'json' do
      subject(:json) { OpenStruct.new JSON.parse(response.body) }

      its(:tag_count) { should eq 3 }
    end
  end
end
