class TransactionsController < ApplicationController
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  acts_as_token_authentication_handler_for User
  before_filter :login_required
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.find_transactions
    users = User.select([:id, :email]).where("id != ?", current_user.id)
    respond_to do |format|
      format.html
      format.json { render :json => {transactions: @transactions, users: users} }
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
    @receive_money = true
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
    build_params
    @transaction = Transaction.new(@parameters)
    if @transaction.save
      @response = Cloudinary::Uploader.upload(@image) if @image.present?
      if @response.present?
        @transaction.update_attributes(image: @response["url"])
      elsif @image.present?
        flash[:error] = "The image was not updated, please try again."
      end
      respond_to do |format|
        format.html { redirect_to @transaction }
        format.json { render :json => @transaction }
      end
    end
  end

  def update
    build_params
    if @transaction.update(@parameters)
      Cloudinary::Api.delete_resources([@transaction.image])
      @response = Cloudinary::Uploader.upload(@image) if @image.present?
      if @response.present?
        @transaction.update_attributes(image: @response["url"])
      elsif @image.present?
        flash[:error] = "The image was not updated, please try again."
      end
      respond_to do |format|
        format.html { redirect_to @transaction }
        format.json { render :json => @transaction }
      end
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

  def build_params
    puts "******** params = #{params}"
    @parameters = transaction_params
    @image      = @parameters.delete(:image)
    @receive_money = @parameters.delete(:receive_money)

    if @receive_money == '1'
      @parameters[:payee_id] = current_user.id
    else
      @parameters[:payer_id] = current_user.id
    end
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
    @receive_money = @transaction.payee_id == current_user.id
    @interested_person = @receive_money ? @transaction.payer_id : @transaction.payee_id
    redirect_to :root unless [@transaction.payee_id, @transaction.payer_id].include?(current_user.id)
  end

  def transaction_params
    params.require(:transaction).permit(:date, :amount, :description, :image, :receive_money, :payer_id, :payee_id)
  end
end
