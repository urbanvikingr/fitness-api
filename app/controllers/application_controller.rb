class ApplicationController < ActionController::Base
  include Pundit
  # before_action :restrict_access_with_omniauth
  skip_before_action :verify_authenticity_token
  before_action :restrict_access
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :json

  protected

  attr_reader :current_user

  # Allows access to current_user in serializators.
  serialization_scope :current_user

  def restrict_access
    begin
      authorization = request.headers["Authorization"]
      raise InvalidTokenError if authorization.nil?
      http_token = authorization.split(" ").last
      new_token = NewToken.new(http_token)
      puts "new_token #{new_token.inspect} aud #{new_token.audience_valid?}"
      decoded_token ||= Token.decode(http_token)
      @current_user = User.find_by(
        provider: decoded_token.provider,
        uid: decoded_token.user_id_from_provider)
    rescue JWT::DecodeError
      raise InvalidTokenError
    end
  end

  def restrict_access_with_omniauth
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(token: token)
    end
  end
end
