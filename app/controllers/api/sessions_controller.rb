module Api
  class SessionsController < ApplicationController
    skip_before_action :restrict_access
    skip_after_action :verify_authorized

    def create
      user = User.from_omniauth(auth_params)
      session[:user_id] = user.id
      render json: user, serializer: SessionSerializer, status: :ok
    end

    def destroy
      session[:user_id] = nil
      render json: {}, status: :ok
    end

    def failure
      render json: { errors: params[:message] }, status: :unauthorized
    end

    private

    def auth_params
      auth_params = request.env.fetch("omniauth.auth")
      auth_params.info["name"] = params.fetch(:name) if params.has_key?(:name)
      auth_params
    end
  end
end
