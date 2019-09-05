require "application_system_test_case"

class DirectResponsesTest < ApplicationSystemTestCase
  setup do
    @direct_response = direct_responses(:one)
  end

  test "visiting the index" do
    visit direct_responses_url
    assert_selector "h1", text: "Direct Responses"
  end

  test "creating a Direct response" do
    visit direct_responses_url
    click_on "New Direct Response"

    fill_in "Response", with: @direct_response.response
    fill_in "Tag", with: @direct_response.tag
    fill_in "Text", with: @direct_response.text
    click_on "Create Direct response"

    assert_text "Direct response was successfully created"
    click_on "Back"
  end

  test "updating a Direct response" do
    visit direct_responses_url
    click_on "Edit", match: :first

    fill_in "Response", with: @direct_response.response
    fill_in "Tag", with: @direct_response.tag
    fill_in "Text", with: @direct_response.text
    click_on "Update Direct response"

    assert_text "Direct response was successfully updated"
    click_on "Back"
  end

  test "destroying a Direct response" do
    visit direct_responses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Direct response was successfully destroyed"
  end
end
