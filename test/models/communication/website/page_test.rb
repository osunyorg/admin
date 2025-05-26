require "test_helper"

# rails test test/models/communication/website/page_test.rb
class Communication::Website::PageTest < ActiveSupport::TestCase

  def test_create_without_slug
    page = Communication::Website::Page.new(new_page_params)
    assert page.save
    assert page.localizations.first.slug.present?
    assert_equal "une-nouvelle-page", page.localizations.first.slug
  end

  def test_create_without_slug_and_conflicting_title
    params = new_page_params
    params[:localizations_attributes].first[:title] = "Test"

    page = Communication::Website::Page.new(params)
    assert page.save
    assert page.localizations.first.slug.present?
    assert_equal "test-1", page.localizations.first.slug
  end

  def test_create_with_taken_slug
    params = new_page_params
    # Force slug to be the same as an existing page
    params[:localizations_attributes].first[:slug] = communication_website_page_localizations(:test_page_fr).slug

    page = Communication::Website::Page.new(params)
    refute page.save
    assert page.errors.of_kind?("localizations.slug", :taken)
  end

  protected

  def new_page_params
    {
      localizations_attributes: [
        {
          title: "Une nouvelle page",
          published: true,
          published_at: Time.zone.now,
          language_id: french.id
        }
      ],
      parent_id: communication_website_pages(:root_page).id,
      communication_website_id: website_with_github.id,
      university_id: default_university.id
    }
  end
end