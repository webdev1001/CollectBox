require 'test_helper'

class BoxesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    post :create, { box: { name: 'Football match' } }
    assert_response :redirect
  end
end
