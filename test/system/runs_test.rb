require "application_system_test_case"

class RunsTest < ApplicationSystemTestCase
  setup do
    @run = runs(:one)
  end

  test "visiting the index" do
    visit runs_url
    assert_selector "h1", text: "Runs"
  end

  test "creating a Run" do
    visit runs_url
    click_on "New Run"

    fill_in "Athlete", with: @run.athlete_id
    fill_in "Bib", with: @run.bib
    fill_in "Course", with: @run.course_id
    fill_in "Current dist", with: @run.current_dist
    fill_in "Status", with: @run.status
    click_on "Create Run"

    assert_text "Run was successfully created"
    click_on "Back"
  end

  test "updating a Run" do
    visit runs_url
    click_on "Edit", match: :first

    fill_in "Athlete", with: @run.athlete_id
    fill_in "Bib", with: @run.bib
    fill_in "Course", with: @run.course_id
    fill_in "Current dist", with: @run.current_dist
    fill_in "Status", with: @run.status
    click_on "Update Run"

    assert_text "Run was successfully updated"
    click_on "Back"
  end

  test "destroying a Run" do
    visit runs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Run was successfully destroyed"
  end
end
