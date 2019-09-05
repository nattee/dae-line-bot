require 'test_helper'

class DirectResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @direct_response = direct_responses(:one)
  end

  test "should get index" do
    get direct_responses_url
    assert_response :success
  end

  test "should get new" do
    get new_direct_response_url
    assert_response :success
  end

  test "should create direct_response" do
    assert_difference('DirectResponse.count') do
      post direct_responses_url, params: { direct_response: { response: @direct_response.response, tag: @direct_response.tag, text: @direct_response.text } }
    end

    assert_redirected_to direct_response_url(DirectResponse.last)
  end

  test "should show direct_response" do
    get direct_response_url(@direct_response)
    assert_response :success
  end

  test "should get edit" do
    get edit_direct_response_url(@direct_response)
    assert_response :success
  end

  test "should update direct_response" do
    patch direct_response_url(@direct_response), params: { direct_response: { response: @direct_response.response, tag: @direct_response.tag, text: @direct_response.text } }
    assert_redirected_to direct_response_url(@direct_response)
  end

  test "should destroy direct_response" do
    assert_difference('DirectResponse.count', -1) do
      delete direct_response_url(@direct_response)
    end

    assert_redirected_to direct_responses_url
  end
end
