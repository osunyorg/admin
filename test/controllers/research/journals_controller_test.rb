require "test_helper"

class Research::JournalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @research_journal = research_journals(:one)
  end

  test "should get index" do
    get research_journals_url
    assert_response :success
  end

  test "should get new" do
    get new_research_journal_url
    assert_response :success
  end

  test "should create research_journal" do
    assert_difference('Research::Journal.count') do
      post research_journals_url, params: { research_journal: { description: @research_journal.description, title: @research_journal.title } }
    end

    assert_redirected_to research_journal_url(Research::Journal.last)
  end

  test "should show research_journal" do
    get research_journal_url(@research_journal)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_journal_url(@research_journal)
    assert_response :success
  end

  test "should update research_journal" do
    patch research_journal_url(@research_journal), params: { research_journal: { description: @research_journal.description, title: @research_journal.title } }
    assert_redirected_to research_journal_url(@research_journal)
  end

  test "should destroy research_journal" do
    assert_difference('Research::Journal.count', -1) do
      delete research_journal_url(@research_journal)
    end

    assert_redirected_to research_journals_url
  end
end
