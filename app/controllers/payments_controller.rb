class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    if payment_params[:done_date] == "now"
      parameters = payment_params.merge(done_date: Time.now)
    end
    # respond_to do |format|
      if @payment.update(parameters)
        if Transaction.find(@payment.transaction_id).payments.where("done_date IS NULL").blank?
          flash[:notice] = "¡Felicidades! has cumplido a tiempo con tus pagos. Puntuación: 100%"
        end
        # redirect_to "/transactions/#{Transaction.find(@payment.transaction_id).id}"
        # format.html { redirect_to "/transactions/#{@payment.transaction.id}" }
        # format.json { render :show, status: :ok, location: @payment }
      else
        flash[:error] = "El pago no se registró"
        # redirect_to "/transactions/#{Transaction.find(@payment.transaction_id).id}"
        # format.html { redirect_to @payment.transaction }
        # format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
      redirect_to "/transactions/#{Transaction.find(@payment.transaction_id).id}"
    # end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:user_transaction_id, :programmed_date, :done_date, :amount, :confirm_payer, :confirm_payee)
    end
end
