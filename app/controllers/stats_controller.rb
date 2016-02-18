class StatsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def show
    @tagged_item = TaggedItem.find_by!(
      entity_type: params[:entity_type],
      entity_identifier: params[:entity_identifier],
    )
  end
end
