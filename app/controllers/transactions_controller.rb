class TransactionsController < ApplicationController
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  acts_as_token_authentication_handler_for User
  before_filter :login_required
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :can_be_edited?, only: [:edit, :update, :destroy]

  def index
    @transactions = current_user.find_transactions
    @users = User.select([:id, :email]).where("id != ?", current_user.id)
    @users_autocomplete = @users.map{|u| u.email + ", ID:" + u.id.to_s}
    respond_to do |format|
      format.html
      format.json { render :json => {transactions: @transactions, users: @users} }
    end
  end

  def show
    @payments = @transaction.payments.order("programmed_date")
    respond_to do |format|
      format.html
      format.json { render :json => @transaction }
    end
  end

  def new
    @transaction = Transaction.new
    @receive_money = true
    @users = User.select([:id, :email]).where("id != ?", current_user.id)
    @users_autocomplete = @users.map{|u| u.email + ", ID:" + u.id.to_s}
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end

  def edit
    @users = User.select([:id, :email]).where("id != ?", current_user.id)
    @users_autocomplete = @users.map{|u| u.email + ", ID:" + u.id.to_s}
  end

  def create
    build_params
    @transaction = Transaction.new(@parameters)
    if @transaction.save
      create_payments
      # @response = Cloudinary::Uploader.upload(@image) if @image.present?
      # if @response.present?
      #   @transaction.update_attributes(image: @response["url"])
      # elsif @image.present?
      #   flash[:error] = "The image was not updated, please try again."
      # end

      respond_to do |format|
        format.html { redirect_to @transaction }
        format.json { render :json => @transaction }
      end
    else
      redirect_to :root
    end
  end

  def update
    build_params
    @users = User.select([:id, :email]).where("id != ?", current_user.id)
    @users_autocomplete = @users.map{|u| u.email + ", ID:" + u.id.to_s}
    if @transaction.update(@parameters)
      @transaction.payments.delete_all
      create_payments
      # Cloudinary::Api.delete_resources([@transaction.image])
      # @response = Cloudinary::Uploader.upload(@image) if @image.present?
      # if @response.present?
      #   @transaction.update_attributes(image: @response["url"])
      # elsif @image.present?
      #   flash[:error] = "The image was not updated, please try again."
      # end
      respond_to do |format|
        format.html { redirect_to @transaction }
        format.json { render :json => @transaction }
      end
    else
      redirect_to :root
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

  def create_payments
    total_interest = (@transaction.interest/100.0) * @transaction.amount
    programmed_amount = (total_interest + @transaction.amount) / @transaction.period.to_f
    @transaction.period.to_i.times do |i|
      @transaction.payments.create(programmed_date: @transaction.date + i.months, amount: programmed_amount)
    end
  end

  def build_params
    puts "******** params = #{params}"
    @parameters = transaction_params
    @parameters[:payee_id] = current_user.id
    @parameters[:seen_by_payee] = true
    @parameters[:confirm_by_payee] = true

    # @image      = @parameters.delete(:image)
    # @receive_money = @parameters.delete(:receive_money)

    # if @receive_money == '1'
    #   @parameters[:payee_id] = current_user.id
    #   @parameters[:seen_by_payee] = true
    # else
    #   @parameters[:payer_id] = current_user.id
    #   @parameters[:seen_by_payer] = true
    # end
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
    # @receive_money = @transaction.payee_id == current_user.id
    # @interested_person = @receive_money ? @transaction.payer_id : @transaction.payee_id
    # redirect_to :root unless [@transaction.payee_id, @transaction.payer_id].include?(current_user.id)
  end

  def can_be_edited?
    redirect_to @transaction if @transaction.confirm_payee and @transaction.confirm_payer
  end

  def transaction_params
    "________ transaction_params"
    params.require(:transaction).permit(:name, :amount, :description, :payer_id, :interest, :period, :date)
    # params.require(:transaction).permit(:date, :amount, :description, :image, :receive_money, :payer_id, :payee_id)
  end
end
