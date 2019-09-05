class DirectResponsesController < ApplicationController
  before_action :set_direct_response, only: [:show, :edit, :update, :destroy]

  # GET /direct_responses
  # GET /direct_responses.json
  def index
    @direct_responses = DirectResponse.all
  end

  # GET /direct_responses/1
  # GET /direct_responses/1.json
  def show
  end

  # GET /direct_responses/new
  def new
    @direct_response = DirectResponse.new
  end

  # GET /direct_responses/1/edit
  def edit
  end

  # POST /direct_responses
  # POST /direct_responses.json
  def create
    @direct_response = DirectResponse.new(direct_response_params)

    respond_to do |format|
      if @direct_response.save
        format.html { redirect_to @direct_response, notice: 'Direct response was successfully created.' }
        format.json { render :show, status: :created, location: @direct_response }
      else
        format.html { render :new }
        format.json { render json: @direct_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /direct_responses/1
  # PATCH/PUT /direct_responses/1.json
  def update
    respond_to do |format|
      if @direct_response.update(direct_response_params)
        format.html { redirect_to @direct_response, notice: 'Direct response was successfully updated.' }
        format.json { render :show, status: :ok, location: @direct_response }
      else
        format.html { render :edit }
        format.json { render json: @direct_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /direct_responses/1
  # DELETE /direct_responses/1.json
  def destroy
    @direct_response.destroy
    respond_to do |format|
      format.html { redirect_to direct_responses_url, notice: 'Direct response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_direct_response
      @direct_response = DirectResponse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def direct_response_params
      params.require(:direct_response).permit(:tag, :text, :response)
    end
end
