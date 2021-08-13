require "application_system_test_case"

class Research::Journal::ArticlesTest < ApplicationSystemTestCase
  setup do
    @research_journal_article = research_journal_articles(:one)
  end

  test "visiting the index" do
    visit research_journal_articles_url
    assert_selector "h1", text: "Research/Journal/Articles"
  end

  test "creating a Article" do
    visit research_journal_articles_url
    click_on "New Research/Journal/Article"

    fill_in "Published at", with: @research_journal_article.published_at
    fill_in "Research journal", with: @research_journal_article.research_journal_id
    fill_in "Research journal volume", with: @research_journal_article.research_journal_volume_id
    fill_in "Text", with: @research_journal_article.text
    fill_in "Title", with: @research_journal_article.title
    fill_in "University", with: @research_journal_article.university_id
    click_on "Create Article"

    assert_text "Article was successfully created"
    click_on "Back"
  end

  test "updating a Article" do
    visit research_journal_articles_url
    click_on "Edit", match: :first

    fill_in "Published at", with: @research_journal_article.published_at
    fill_in "Research journal", with: @research_journal_article.research_journal_id
    fill_in "Research journal volume", with: @research_journal_article.research_journal_volume_id
    fill_in "Text", with: @research_journal_article.text
    fill_in "Title", with: @research_journal_article.title
    fill_in "University", with: @research_journal_article.university_id
    click_on "Update Article"

    assert_text "Article was successfully updated"
    click_on "Back"
  end

  test "destroying a Article" do
    visit research_journal_articles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Article was successfully destroyed"
  end
end
