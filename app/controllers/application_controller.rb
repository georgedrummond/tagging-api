class ApplicationController < ActionController::Base
  before_action :set_default_response_format

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    respond_to do |format|
      format.json { render text: '{"error": "Not found"}', status: :not_found }
    end
  end

  def set_default_response_format
    request.format = :json
  end
end
