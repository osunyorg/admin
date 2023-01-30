require "application_system_test_case"

class Research::Journal::Paper::KindsTest < ApplicationSystemTestCase
  setup do
    @research_journal_paper_kind = research_journal_paper_kinds(:one)
  end

  test "visiting the index" do
    visit research_journal_paper_kinds_url
    assert_selector "h1", text: "Kinds"
  end

  test "should create kind" do
    visit research_journal_paper_kinds_url
    click_on "New kind"

    fill_in "Slug", with: @research_journal_paper_kind.slug
    fill_in "Title", with: @research_journal_paper_kind.title
    click_on "Create Kind"

    assert_text "Kind was successfully created"
    click_on "Back"
  end

  test "should update Kind" do
    visit research_journal_paper_kind_url(@research_journal_paper_kind)
    click_on "Edit this kind", match: :first

    fill_in "Slug", with: @research_journal_paper_kind.slug
    fill_in "Title", with: @research_journal_paper_kind.title
    click_on "Update Kind"

    assert_text "Kind was successfully updated"
    click_on "Back"
  end

  test "should destroy Kind" do
    visit research_journal_paper_kind_url(@research_journal_paper_kind)
    click_on "Destroy this kind", match: :first

    assert_text "Kind was successfully destroyed"
  end
end
