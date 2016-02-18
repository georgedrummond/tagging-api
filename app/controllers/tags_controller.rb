class TagsController < ApplicationController
  before_action :load_tagged_item, only: [:show, :destroy]

  def create
    @tagged_item = TaggedItem.find_or_create_by(
      entity_type: params[:entity_type],
      entity_identifier: params[:entity_identifier],
    )

    if @tagged_item && @tagged_item.valid?
      @tagged_item.assign_tags(*params[:tags])
      render :show, status: :created
    else
      head :bad_request
    end
  end

  def destroy
    @tagged_item.destroy!
    head :no_content
  end

  def show
    render :show
  end

  private

  def load_tagged_item
    @tagged_item = TaggedItem.find_by!(
      entity_type: params[:entity_type],
      entity_identifier: params[:entity_identifier]
    )
  end
end
