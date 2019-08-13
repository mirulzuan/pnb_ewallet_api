class WalletsController < ApplicationController
  before_action :authorize_request
  before_action :set_wallet, only: [:show, :transfer]

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
      @target_wallet.lock!

      @source_wallet.credit -= transaction_params[:amount].to_d
      @target_wallet.credit += transaction_params[:amount].to_d

      if @source_wallet.save!
        debit = @source_wallet.debit_txns.new(transaction_params)
        debit.user_id = @current_user.id
        debit.save!

        render json: @source_wallet, status: :created, location: @source_wallet
      else
        render json: @source_wallet.errors, status: :unprocessable_entity
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
    params.require(:wallet_transaction).permit(:target_wallet_id, :amount)
  end
end
