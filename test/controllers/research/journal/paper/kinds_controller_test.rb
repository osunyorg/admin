require "test_helper"

class Research::Journal::Paper::KindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @research_journal_paper_kind = research_journal_paper_kinds(:one)
  end

  test "should get index" do
    get research_journal_paper_kinds_url
    assert_response :success
  end

  test "should get new" do
    get new_research_journal_paper_kind_url
    assert_response :success
  end

  test "should create research_journal_paper_kind" do
    assert_difference("Research::Journal::Paper::Kind.count") do
      post research_journal_paper_kinds_url, params: { research_journal_paper_kind: { slug: @research_journal_paper_kind.slug, title: @research_journal_paper_kind.title } }
    end

    assert_redirected_to research_journal_paper_kind_url(Research::Journal::Paper::Kind.last)
  end

  test "should show research_journal_paper_kind" do
    get research_journal_paper_kind_url(@research_journal_paper_kind)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_journal_paper_kind_url(@research_journal_paper_kind)
    assert_response :success
  end

  test "should update research_journal_paper_kind" do
    patch research_journal_paper_kind_url(@research_journal_paper_kind), params: { research_journal_paper_kind: { slug: @research_journal_paper_kind.slug, title: @research_journal_paper_kind.title } }
    assert_redirected_to research_journal_paper_kind_url(@research_journal_paper_kind)
  end

  test "should destroy research_journal_paper_kind" do
    assert_difference("Research::Journal::Paper::Kind.count", -1) do
      delete research_journal_paper_kind_url(@research_journal_paper_kind)
    end

    assert_redirected_to research_journal_paper_kinds_url
  end
end
