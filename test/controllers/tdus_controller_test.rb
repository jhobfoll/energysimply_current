require 'test_helper'

class TdusControllerTest < ActionController::TestCase
  setup do
    @tdu = tdus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tdus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tdu" do
    assert_difference('Tdu.count') do
      post :create, tdu: { apt_avg: @tdu.apt_avg, apt_best: @tdu.apt_best, house_avg: @tdu.house_avg, house_best: @tdu.house_best, name: @tdu.name }
    end

    assert_redirected_to tdu_path(assigns(:tdu))
  end

  test "should show tdu" do
    get :show, id: @tdu
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tdu
    assert_response :success
  end

  test "should update tdu" do
    patch :update, id: @tdu, tdu: { apt_avg: @tdu.apt_avg, apt_best: @tdu.apt_best, house_avg: @tdu.house_avg, house_best: @tdu.house_best, name: @tdu.name }
    assert_redirected_to tdu_path(assigns(:tdu))
  end

  test "should destroy tdu" do
    assert_difference('Tdu.count', -1) do
      delete :destroy, id: @tdu
    end

    assert_redirected_to tdus_path
  end
end
