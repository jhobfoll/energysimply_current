require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  setup do
    @bill = bills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bill" do
    assert_difference('Bill.count') do
      post :create, bill: { : @bill., account_number: @bill.account_number, current_provider: @bill.current_provider, energy_charge: @bill.energy_charge, esi_id: @bill.esi_id, kwh_usage: @bill.kwh_usage, last_bill_amount: @bill.last_bill_amount, meter_number: @bill.meter_number, plan_end_date: @bill.plan_end_date, svc_address_1: @bill.svc_address_1, svc_address_2: @bill.svc_address_2, usage_charge: @bill.usage_charge }
    end

    assert_redirected_to bill_path(assigns(:bill))
  end

  test "should show bill" do
    get :show, id: @bill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bill
    assert_response :success
  end

  test "should update bill" do
    patch :update, id: @bill, bill: { : @bill., account_number: @bill.account_number, current_provider: @bill.current_provider, energy_charge: @bill.energy_charge, esi_id: @bill.esi_id, kwh_usage: @bill.kwh_usage, last_bill_amount: @bill.last_bill_amount, meter_number: @bill.meter_number, plan_end_date: @bill.plan_end_date, svc_address_1: @bill.svc_address_1, svc_address_2: @bill.svc_address_2, usage_charge: @bill.usage_charge }
    assert_redirected_to bill_path(assigns(:bill))
  end

  test "should destroy bill" do
    assert_difference('Bill.count', -1) do
      delete :destroy, id: @bill
    end

    assert_redirected_to bills_path
  end
end
