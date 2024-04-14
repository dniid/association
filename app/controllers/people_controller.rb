class PeopleController < ApplicationController
  include PaginationConcern

  before_action :set_person, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  PEOPLE_PER_PAGE = 100

  # GET /people or /people.json
  def index
    @active = params[:active] ? params[:active] == 'true' : true
    @pagination, @people = paginate(collection: Person.where(active: @active).includes(:user), params: page_params)
  end

  # GET /people/search?q=a_name
  # Returns an HTML for autocomplete
  def search
    @people = Person.where(active: true).
      where("UPPER(name) LIKE ?", "#{params[:q].upcase}%").
      order(:name).
      limit(10)

    respond_to do |format|
      format.html { render :search, layout: false }
      format.json { render json: @people.to_json }
    end
  end

  # GET /people/1 or /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new active: true
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    @person.user = current_user

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Criado com sucesso." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Removido." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :phone_number, :national_id, :active)
    end

    def page_params
      params.permit(:page).merge(per_page: PEOPLE_PER_PAGE)
    end
end
