class Admin::Research::JournalsController < Admin::Research::Journal::ApplicationController
  load_and_authorize_resource class: Research::Journal

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
  end

  def create
    @journal.university = current_university
    if @journal.save
      redirect_to [:admin, @journal], notice: "Journal was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @journal.update(journal_params)
      redirect_to [:admin, @journal], notice: "Journal was successfully updated."
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @journal.destroy
    redirect_to admin_research_journals_url, notice: "Journal was successfully destroyed."
  end

  protected

  def journal_params
    params.require(:research_journal).permit(:title, :description)
  end
end
