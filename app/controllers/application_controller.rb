class ApplicationController < ActionController::Base
  include Pundit
  skip_before_action :verify_authenticity_token
  before_action :preflight_check
  before_action :restrict_access
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :json

  protected

  attr_reader :current_user

  # Allows access to current_user in serializators.
  serialization_scope :current_user

  def preflight_check
    puts request.headers.inspect
    headers["Access-Control-Max-Age"] = "1728000"
    render json: {}
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(token: token)
    end
  end
end
