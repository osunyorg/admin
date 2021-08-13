class Research::Journal::VolumesController < ApplicationController
  before_action :set_research_journal_volume, only: %i[ show edit update destroy ]

  # GET /research/journal/volumes or /research/journal/volumes.json
  def index
    @research_journal_volumes = Research::Journal::Volume.all
  end

  # GET /research/journal/volumes/1 or /research/journal/volumes/1.json
  def show
  end

  # GET /research/journal/volumes/new
  def new
    @research_journal_volume = Research::Journal::Volume.new
  end

  # GET /research/journal/volumes/1/edit
  def edit
  end

  # POST /research/journal/volumes or /research/journal/volumes.json
  def create
    @research_journal_volume = Research::Journal::Volume.new(research_journal_volume_params)

    respond_to do |format|
      if @research_journal_volume.save
        format.html { redirect_to @research_journal_volume, notice: "Volume was successfully created." }
        format.json { render :show, status: :created, location: @research_journal_volume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @research_journal_volume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /research/journal/volumes/1 or /research/journal/volumes/1.json
  def update
    respond_to do |format|
      if @research_journal_volume.update(research_journal_volume_params)
        format.html { redirect_to @research_journal_volume, notice: "Volume was successfully updated." }
        format.json { render :show, status: :ok, location: @research_journal_volume }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @research_journal_volume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /research/journal/volumes/1 or /research/journal/volumes/1.json
  def destroy
    @research_journal_volume.destroy
    respond_to do |format|
      format.html { redirect_to research_journal_volumes_url, notice: "Volume was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_research_journal_volume
      @research_journal_volume = Research::Journal::Volume.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def research_journal_volume_params
      params.require(:research_journal_volume).permit(:title, :number, :published_at)
    end
end
