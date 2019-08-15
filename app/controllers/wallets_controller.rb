class WalletsController < ApplicationController
  before_action :authorize_request
  before_action :set_wallet, only: [:show, :transfer]

  # GET /wallets
  def index
    @wallets = Wallet.joins(:user).select("wallets.*, users.role").group_by(&:role).as_json

    render json: @wallets
  end

  # GET /wallets/1
  def show
    render json: @wallet
  end

  # POST /wallets
  def transfer
    Wallet.transaction do
      @source_wallet = @wallet
      @target_wallet = Wallet.find(transaction_params[:target_wallet_id])

      @source_wallet.lock!
      @source_wallet.credit -= transaction_params[:amount].to_d
      @source_wallet.amount_transferred = transaction_params[:amount].to_d
      @source_wallet.pin = transaction_params[:pin]

      @target_wallet.lock!
      @target_wallet.credit += transaction_params[:amount].to_d

      if @source_wallet.save
        @target_wallet.save(validate: false)
        debit = @source_wallet.debit_txns.new(transaction_params)
        debit.user_id = @current_user.id
        debit.save!

        render json: @source_wallet, status: :created, location: @source_wallet
      else
        render json: @source_wallet.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_wallet
    @wallet = @current_user.wallets.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def transaction_params
    params.require(:wallet_transaction).permit(:target_wallet_id, :amount, :pin)
  end
end
