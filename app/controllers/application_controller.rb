class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  private

  def record_not_found(exception)
    log_error(exception)
    render json: TaskSerializer.serialize_errors("Record not found", metadata: metadata), status: :not_found
  end

  def parameter_missing(exception)
    render json: TaskSerializer.serialize_errors(exception.message, metadata: metadata), status: :unprocessable_entity
  end

  def metadata
    {
      timestamp: Time.current,
      api_version: "v1"
    }
  end

  def log_error(exception)
    Rails.logger.error("[#{exception.class}] #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n")) if Rails.env.development?
  end
end
