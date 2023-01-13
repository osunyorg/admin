class Admin::Research::DocumentsController < Admin::Research::ApplicationController

  def index
    @documents = current_university.research_documents.page(params[:page])
    breadcrumb
  end

  def show
    @document = Research::Document.find params[:id]
    breadcrumb
  end

  def update
    @document = Research::Document.find params[:id]
    redirect_to admin_research_document_path(@document)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Document.model_name.human(count: 2),
                   admin_research_documents_path
    breadcrumb_for @document
  end

end
