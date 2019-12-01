require_relative '../tools/app_exception.rb'
# Helper for valid? method
module ValidateHelper
  def valid?
    validate!
    true
  rescue AppException::AppError
    false
  end

  protected

  def validate!; end
end
