class ApplicationController < ActionController::API
  # Handles common exceptions like record not found or parameter errors
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  private

  # Handles ActiveRecord::RecordNotFound exceptions
  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  # Handles ActionController::ParameterMissing exceptions
  def parameter_missing(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
