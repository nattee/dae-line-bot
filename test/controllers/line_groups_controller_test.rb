require 'test_helper'

class LineGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_group = line_groups(:one)
  end

  test "should get index" do
    get line_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_line_group_url
    assert_response :success
  end

  test "should create line_group" do
    assert_difference('LineGroup.count') do
      post line_groups_url, params: { line_group: { line_group_id: @line_group.line_group_id, line_id: @line_group.line_id, race_id: @line_group.race_id } }
    end

    assert_redirected_to line_group_url(LineGroup.last)
  end

  test "should show line_group" do
    get line_group_url(@line_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_group_url(@line_group)
    assert_response :success
  end

  test "should update line_group" do
    patch line_group_url(@line_group), params: { line_group: { line_group_id: @line_group.line_group_id, line_id: @line_group.line_id, race_id: @line_group.race_id } }
    assert_redirected_to line_group_url(@line_group)
  end

  test "should destroy line_group" do
    assert_difference('LineGroup.count', -1) do
      delete line_group_url(@line_group)
    end

    assert_redirected_to line_groups_url
  end
end
