require "application_system_test_case"

class ShortLinksTest < ApplicationSystemTestCase
  setup do
    @short_link = short_links(:one)
  end

  test "visiting the index" do
    visit short_links_url
    assert_selector "h1", text: "Short links"
  end

  test "should create short link" do
    visit short_links_url
    click_on "New short link"

    fill_in "Clicked", with: @short_link.clicked
    fill_in "Origin url", with: @short_link.origin_url
    fill_in "Code", with: @short_link.code
    click_on "Create Short link"

    assert_text "Short link was successfully created"
    click_on "Back"
  end

  test "should update Short link" do
    visit short_link_url(@short_link)
    click_on "Edit this short link", match: :first

    fill_in "Clicked", with: @short_link.clicked
    fill_in "Origin url", with: @short_link.origin_url
    fill_in "Code", with: @short_link.code
    click_on "Update Short link"

    assert_text "Short link was successfully updated"
    click_on "Back"
  end

  test "should destroy Short link" do
    visit short_link_url(@short_link)
    click_on "Destroy this short link", match: :first

    assert_text "Short link was successfully destroyed"
  end
end
