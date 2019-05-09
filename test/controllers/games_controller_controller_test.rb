require 'test_helper'

class GamesControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get games_controller_new_url
    assert_response :success
  end

  test "should get score" do
    get games_controller_score_url
    assert_response :success
  end

end
