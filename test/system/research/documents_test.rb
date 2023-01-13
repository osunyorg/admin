require "application_system_test_case"

class Research::DocumentsTest < ApplicationSystemTestCase
  setup do
    @research_document = research_documents(:one)
  end

  test "visiting the index" do
    visit research_documents_url
    assert_selector "h1", text: "Documents"
  end

  test "should create document" do
    visit research_documents_url
    click_on "New document"

    fill_in "Data", with: @research_document.data
    fill_in "Docid", with: @research_document.docid
    fill_in "Ref", with: @research_document.ref
    fill_in "Title", with: @research_document.title
    fill_in "University", with: @research_document.university_id
    fill_in "University person", with: @research_document.university_person_id
    fill_in "Url", with: @research_document.url
    click_on "Create Document"

    assert_text "Document was successfully created"
    click_on "Back"
  end

  test "should update Document" do
    visit research_document_url(@research_document)
    click_on "Edit this document", match: :first

    fill_in "Data", with: @research_document.data
    fill_in "Docid", with: @research_document.docid
    fill_in "Ref", with: @research_document.ref
    fill_in "Title", with: @research_document.title
    fill_in "University", with: @research_document.university_id
    fill_in "University person", with: @research_document.university_person_id
    fill_in "Url", with: @research_document.url
    click_on "Update Document"

    assert_text "Document was successfully updated"
    click_on "Back"
  end

  test "should destroy Document" do
    visit research_document_url(@research_document)
    click_on "Destroy this document", match: :first

    assert_text "Document was successfully destroyed"
  end
end
