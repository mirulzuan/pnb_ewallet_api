class WalletsController < ApplicationController
  before_action :authorize_request
  before_action :set_wallet, only: [:show, :transfer]

  # GET /wallets/1
  def show
    render json: @wallet
  end

  # POST /wallets
  def transfer
    @debit = @wallet.debit_txns.new(transaction_params)
    @debit.user_id = @current_user.id

    if @debit.save
      render json: @wallet, status: :created, location: @wallet
    else
      render json: @debit.errors, status: :unprocessable_entity
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
