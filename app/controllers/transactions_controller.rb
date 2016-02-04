class TransactionsController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_filter :login_required
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.find_transactions
    respond_to do |format|
      format.html
      format.json { render :json => @transactions }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render :json => @transaction }
    end
  end

  def new
    @transaction = Transaction.new
    @users = User.select([:id, :email]).where("id != ?", current_user.id)
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end

  def edit
    @users = User.select([:id, :email]).where("id != ?", current_user.id)
  end

  def create
    @parameters = transaction_params
    @interested = @parameters.delete(:interested)
    @receive_money = @parameters.delete(:receive_money)
    @parameters[:payee_id] = @receive_money ? current_user.id : @interested
    @parameters[:payer_id] = @receive_money ? @interested : current_user.id
    @transaction = Transaction.new(@parameters)
    @transaction.save
    respond_to do |format|
      format.html { redirect_to @transaction }
      format.json { render :json => @transaction }
    end
  end

  def update
    @parameters = transaction_params
    @interested = @parameters.delete(:interested)
    @receive_money = @parameters.delete(:receive_money)
    @parameters[:payee_id] = @receive_money ? current_user.id : @interested
    @parameters[:payer_id] = @receive_money ? @interested : current_user.id
    @transaction.update(@parameters)
    respond_to do |format|
      format.html { redirect_to @transaction }
      format.json { render :json => @transaction }
    end
  end

  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to :root }
      format.json { render :json => @transaction }
    end
  end

private

  def set_transaction
    @transaction = Transaction.find(params[:id])
    redirect_to :root unless [@transaction.payee_id, @transaction.payer_id].include?(current_user.id)
  end

  def transaction_params
    params.require(:transaction).permit(:date, :amount, :description, :image, :receive_money, :interested)
  end
end
