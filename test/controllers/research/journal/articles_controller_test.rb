require "test_helper"

class Research::Journal::ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @research_journal_article = research_journal_articles(:one)
  end

  test "should get index" do
    get research_journal_articles_url
    assert_response :success
  end

  test "should get new" do
    get new_research_journal_article_url
    assert_response :success
  end

  test "should create research_journal_article" do
    assert_difference('Research::Journal::Article.count') do
      post research_journal_articles_url, params: { research_journal_article: { published_at: @research_journal_article.published_at, research_journal_id: @research_journal_article.research_journal_id, research_journal_volume_id: @research_journal_article.research_journal_volume_id, text: @research_journal_article.text, title: @research_journal_article.title, university_id: @research_journal_article.university_id } }
    end

    assert_redirected_to research_journal_article_url(Research::Journal::Article.last)
  end

  test "should show research_journal_article" do
    get research_journal_article_url(@research_journal_article)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_journal_article_url(@research_journal_article)
    assert_response :success
  end

  test "should update research_journal_article" do
    patch research_journal_article_url(@research_journal_article), params: { research_journal_article: { published_at: @research_journal_article.published_at, research_journal_id: @research_journal_article.research_journal_id, research_journal_volume_id: @research_journal_article.research_journal_volume_id, text: @research_journal_article.text, title: @research_journal_article.title, university_id: @research_journal_article.university_id } }
    assert_redirected_to research_journal_article_url(@research_journal_article)
  end

  test "should destroy research_journal_article" do
    assert_difference('Research::Journal::Article.count', -1) do
      delete research_journal_article_url(@research_journal_article)
    end

    assert_redirected_to research_journal_articles_url
  end
end
