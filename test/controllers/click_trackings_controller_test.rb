require 'test_helper'

class ClickTrackingsControllerTest < ActionController::TestCase
  setup do
    @click_tracking = click_trackings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:click_trackings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create click_tracking" do
    assert_difference('ClickTracking.count') do
      post :create, click_tracking: { url: @click_tracking.url, user_id: @click_tracking.user_id, zip: @click_tracking.zip }
    end

    assert_redirected_to click_tracking_path(assigns(:click_tracking))
  end

  test "should show click_tracking" do
    get :show, id: @click_tracking
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @click_tracking
    assert_response :success
  end

  test "should update click_tracking" do
    patch :update, id: @click_tracking, click_tracking: { url: @click_tracking.url, user_id: @click_tracking.user_id, zip: @click_tracking.zip }
    assert_redirected_to click_tracking_path(assigns(:click_tracking))
  end

  test "should destroy click_tracking" do
    assert_difference('ClickTracking.count', -1) do
      delete :destroy, id: @click_tracking
    end

    assert_redirected_to click_trackings_path
  end
end
