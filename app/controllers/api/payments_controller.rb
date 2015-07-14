# Will Payment#update and Payment#delete be used?
# Post a transaction with negative amount to "delete" sale
# What attribute(s) should be editable on Payment?
# Move Payment#create into Sale::CreatePayment
module Api
  class PaymentsController < ApplicationController
    skip_after_action :verify_authorized, only: :new
    before_action :set_payment, only: [:show, :update, :destroy]

    # GET /payments.json
    def index
      render json: policy_scope(Payment).order(:transaction_id), status: :ok
    end

    # GET /payments/1.json
    def show
      render json: @payment, status: :ok
    end

    # GET /payments/new.json
    def new
      @client_token = Sale::GenerateClientToken.new.client_token
      render json: { client_token: @client_token }, status: :ok
    end

    # POST /payments.json
    def create
      @payment = Payment.new(payment_params)
      @payment.user = current_user
      authorize @payment

      if @payment.save
        render json: @payment, status: :created
      else
        render json: { errors: @payment.errors }, status: :unprocessable_entity
      end
    end

    # PUT /payments/1.json
    def update
      if @payment.update(payment_params)
        render json: @payment, status: :ok
      else
        render json: { errors: @payment.errors }, status: :unprocessable_entity, location: nil
      end
    end

    # DELETE /payments/1.json
    def destroy
      @payment.destroy
      head :no_content
    end

    private

    def payment_params
      params.require(:payment).
        permit(:amount,
               :currency,
               :payment_method_nonce,
               :product_id)
    end

    def set_payment
      @payment = Payment.find(payment_id)
      authorize @payment
    end

    def payment_id
      params.fetch(:id)
    end
  end
end
