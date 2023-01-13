require "test_helper"

class Research::DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @research_document = research_documents(:one)
  end

  test "should get index" do
    get research_documents_url
    assert_response :success
  end

  test "should get new" do
    get new_research_document_url
    assert_response :success
  end

  test "should create research_document" do
    assert_difference("Research::Document.count") do
      post research_documents_url, params: { research_document: { data: @research_document.data, docid: @research_document.docid, ref: @research_document.ref, title: @research_document.title, university_id: @research_document.university_id, university_person_id: @research_document.university_person_id, url: @research_document.url } }
    end

    assert_redirected_to research_document_url(Research::Document.last)
  end

  test "should show research_document" do
    get research_document_url(@research_document)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_document_url(@research_document)
    assert_response :success
  end

  test "should update research_document" do
    patch research_document_url(@research_document), params: { research_document: { data: @research_document.data, docid: @research_document.docid, ref: @research_document.ref, title: @research_document.title, university_id: @research_document.university_id, university_person_id: @research_document.university_person_id, url: @research_document.url } }
    assert_redirected_to research_document_url(@research_document)
  end

  test "should destroy research_document" do
    assert_difference("Research::Document.count", -1) do
      delete research_document_url(@research_document)
    end

    assert_redirected_to research_documents_url
  end
end
