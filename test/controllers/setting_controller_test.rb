require 'test_helper'

class SettingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get setting_index_url
    assert_response :success
  end

  test "should get page" do
    get setting_page_url
    assert_response :success
  end

end
