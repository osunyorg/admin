require "application_system_test_case"

class Communication::Website::BlocksTest < ApplicationSystemTestCase
  setup do
    @communication_website_block = communication_website_blocks(:one)
  end

  test "visiting the index" do
    visit communication_website_blocks_url
    assert_selector "h1", text: "Communication/Website/Blocks"
  end

  test "creating a Block" do
    visit communication_website_blocks_url
    click_on "New Communication/Website/Block"

    fill_in "About", with: @communication_website_block.about_id
    fill_in "Communication website", with: @communication_website_block.communication_website_id
    fill_in "Data", with: @communication_website_block.data
    fill_in "Position", with: @communication_website_block.position
    fill_in "Template", with: @communication_website_block.template
    fill_in "University", with: @communication_website_block.university_id
    click_on "Create Block"

    assert_text "Block was successfully created"
    click_on "Back"
  end

  test "updating a Block" do
    visit communication_website_blocks_url
    click_on "Edit", match: :first

    fill_in "About", with: @communication_website_block.about_id
    fill_in "Communication website", with: @communication_website_block.communication_website_id
    fill_in "Data", with: @communication_website_block.data
    fill_in "Position", with: @communication_website_block.position
    fill_in "Template", with: @communication_website_block.template
    fill_in "University", with: @communication_website_block.university_id
    click_on "Update Block"

    assert_text "Block was successfully updated"
    click_on "Back"
  end

  test "destroying a Block" do
    visit communication_website_blocks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Block was successfully destroyed"
  end
end
