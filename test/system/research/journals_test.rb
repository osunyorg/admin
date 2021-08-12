require "application_system_test_case"

class Research::JournalsTest < ApplicationSystemTestCase
  setup do
    @research_journal = research_journals(:one)
  end

  test "visiting the index" do
    visit research_journals_url
    assert_selector "h1", text: "Research/Journals"
  end

  test "creating a Journal" do
    visit research_journals_url
    click_on "New Research/Journal"

    fill_in "Description", with: @research_journal.description
    fill_in "Title", with: @research_journal.title
    click_on "Create Journal"

    assert_text "Journal was successfully created"
    click_on "Back"
  end

  test "updating a Journal" do
    visit research_journals_url
    click_on "Edit", match: :first

    fill_in "Description", with: @research_journal.description
    fill_in "Title", with: @research_journal.title
    click_on "Update Journal"

    assert_text "Journal was successfully updated"
    click_on "Back"
  end

  test "destroying a Journal" do
    visit research_journals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Journal was successfully destroyed"
  end
end
