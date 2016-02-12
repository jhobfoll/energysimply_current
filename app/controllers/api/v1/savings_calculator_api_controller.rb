module Api
  module V1
    class SavingsCalculatorApiController < ApplicationController

      skip_before_filter :verify_authenticity_token,
        :if => Proc.new { |c| c.request.format == 'application/json' }

######

  	  def savings_tdu_list

        @zip_for_calculate = ( @zip.present? ? @zip.zip : (params[:calculator_zip]) );
        @bill_month = (params[:calculator_bill_month])
        @bill_mo_cost = (params[:calculator_bill_mo_cost])
        @bill_kwh = (params[:calculator_bill_kwh])

        @calculator_data_savings = true

        # Lookup here for relevant plans to pass to Rob's js
        # find which TDU is for zip given, then return all records 12-mo
        # - default cheapest & renewable if radio set

        unless (  @zip_for_calculate.present? && @bill_month.present? &&
                  @bill_mo_cost.present? && @bill_kwh.present?
               )
          render :json => {:error => "Missing Input Params"}.to_json, :status => 200
          return
        end

        @tdu_name = Zip.where( 'zip = ?', @zip_for_calculate ).first.tdu_name
        puts ">>>>>>>>>>>>> OUR TDU NAME: " + @tdu_name.inspect

        unless @tdu_name.present?
          render :json => {:error => "No TDU Found For That Zip"}.to_json, :status => 200
          return
        end

        unless (params[:plan_type]) == "Most_Affordable_Renewable"
          @relevantTDUs = SavingsCalculatorDatum.
            where('TduCompanyName = ?', @tdu_name).
            where('TermValue = ?', 12)
        else
          @relevantTDUs = SavingsCalculatorDatum.
            where('TduCompanyName = ?', @tdu_name).
            where('TermValue = ?', 12).
            where('Renewable = ?', 100)
        end

        # puts ">>>>>>>>>>>>> OUR TDU SET: " + @relevantTDUs.inspect
        puts ">>>>>>>>>>>>> OUR TDU Company-Plan Count: " + @relevantTDUs.count.to_s


        unless @relevantTDUs.count > 0
          render :json => {:error => "No Companies with spec-plans found for that TDU"}.to_json, :status => 200
          return
        end

  		  render :json => {:TDU_Data => @relevantTDUs }.to_json, :status => 200

      end

    end # class
  end # module v1
end # module api
