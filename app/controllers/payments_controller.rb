class PaymentsController < ApplicationController
  include PaginationConcern

  before_action :authenticate_user!

  PAYMENTS_PER_PAGE = 10

  # GET /payments or /payments.json
  def index
    @pagination, @payments = paginate(collection: Payment.includes(:person), params: page_params)
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # POST /payments or /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payment_url(@payment), notice: "Pagamento criado." }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy!

    respond_to do |format|
      format.html { redirect_to payments_url, notice: "Pagamento removido." }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:person_id, :amount, :paid_at)
    end

    def page_params
      params.permit(:page).merge(per_page: PAYMENTS_PER_PAGE)
    end
end
