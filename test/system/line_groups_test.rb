require "application_system_test_case"

class LineGroupsTest < ApplicationSystemTestCase
  setup do
    @line_group = line_groups(:one)
  end

  test "visiting the index" do
    visit line_groups_url
    assert_selector "h1", text: "Line Groups"
  end

  test "creating a Line group" do
    visit line_groups_url
    click_on "New Line Group"

    fill_in "Line group", with: @line_group.line_group_id
    fill_in "Line", with: @line_group.line_id
    fill_in "Race", with: @line_group.race_id
    click_on "Create Line group"

    assert_text "Line group was successfully created"
    click_on "Back"
  end

  test "updating a Line group" do
    visit line_groups_url
    click_on "Edit", match: :first

    fill_in "Line group", with: @line_group.line_group_id
    fill_in "Line", with: @line_group.line_id
    fill_in "Race", with: @line_group.race_id
    click_on "Update Line group"

    assert_text "Line group was successfully updated"
    click_on "Back"
  end

  test "destroying a Line group" do
    visit line_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Line group was successfully destroyed"
  end
end
