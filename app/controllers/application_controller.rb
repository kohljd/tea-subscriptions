class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def not_found_error(exception)
    render json: { errors: [{status: 404, details: exception.message }] }, status: :not_found
  end
end
