class ComparePowerPlansController < ApplicationController

  require 'uri'

	def compare_power_plans
    if ((params[:reset]).present? && (params[:reset]) == 'true')
      if current_user.present?
        sign_out(current_user)
        redirect_to compare_power_plans_path(reset: 'true')
        return
      else
        reset_visitor
      end
      @zip = nil
    else
      zip_get # takes care of current_user and @visitor and sets @zip
    end

    if @zip.present?
      puts "---------cppc#cpp @zip.present true"
      @companies = Company.where('tdu_name = ?', @zip.tdu_name)
      get_home_type
      @state= @zip.postal_state

    else #Get Here if:  No zip for user yet, so getting to this page required a state-selection at some point
      puts "---------cppc#cpp @zip.present false"
      url_path = URI.parse(request.fullpath).path
      state = (url_path).gsub( /\/compare-power-plans[\/]?/, '' )
      if state.present?
        set_visitor_state(state)   # sets @state
      else
        get_visitor_state
      end

      #  Show 1 record for each of all companies in state selected
      @companies_unique_names = Company.where('postal_state = ?', @state).
         select(:company_name).distinct

      @companies = []
      @companies_unique_names.each do |company|
        @companies << Company.where('company_name = ?', company.company_name).first
      end

      @zip = nil
    end
  end



  def review
    @no_match_company_TDU = false
    if ((params[:reset]).present? && (params[:reset]) == 'true')
      if current_user.present?
        sign_out(current_user)
        redirect_to compare_power_plans_path
        return
      else
       reset_visitor
      end
       @zip = nil
    else
      zip_get # handles current_user and @visitor and sets @zip
      get_home_type
    end

    if ( (params[:company_name]).present? ) # From Zip Form On Review Page
      company_name_unescaped = URI.decode(params[:company_name])
      puts "-----------company_name_unescaped: " + company_name_unescaped
      @company = nil
      if @zip.present?
        @company = Company.
          where('company_name = ? AND tdu_name = ?', company_name_unescaped, @zip.tdu_name).first
      end
      if @company.blank? # zip not in table at all, or no match of company to zip-area
        @company = Company.where('id = ?', params[:id]).first
        @no_match_company_TDU = true
      end

    elsif ( (params[:id]).blank? && @zip.blank? ) # For SEO Bot
      url_path = URI.parse(request.fullpath).path
      orig_company_name = extract_company_name(url_path) # method in Application Controller
      @company = Company.where('company_name = ?', orig_company_name).first

    elsif ( (params[:id]).present? && @zip.blank? ) # Co-Select by Link w/o Zip Specified
      @company = Company.where('id = ?', params[:id]).first

    elsif ( (params[:id]).present? && @zip.present? ) # Co-Select by Link for logged-in user
      @company = Company.where('id = ?', params[:id]).first
    end

    @co_url_click = "/offsite-click/track?zip=" + (@zip.present? ? @zip.zip : "") + "&url=" + "http://" + CGI.escape(@company.url_main) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")
    @ptc_click = "/offsite-click/track?zip=" + (@zip.present? ? @zip.zip : "") + "&url=" + CGI.escape(@company.ptc_url) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")
    @bbb_click = "/offsite-click/track?zip=" + (@zip.present? ? @zip.zip : "")+ "&url=" + CGI.escape(@company.bbb_url) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")

    if ( @zip.present? && (@no_match_company_TDU == false) )
      # The list on prev-page has already narrowed Company results to their TDU
      @show_plan_specifics = true
      @zip = current_user.zip if @zip.blank?
      # may not be a zip here if w/o zip to main-off-site link
      @co_gen_enroll = "/offsite-click/track?zip=" + @zip.zip + "&url=" + CGI.escape(@company.gen_url_enroll) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")
      @co_ren_enroll = "/offsite-click/track?zip=" + @zip.zip + "&url=" + CGI.escape(@company.ren_url_enroll) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")
      @co_gen_factsheet = "/offsite-click/track?zip=" + @zip.zip + "&url=" + CGI.escape(@company.gen_factsheet_url) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")
      @co_ren_factsheet= "/offsite-click/track?zip=" + @zip.zip + "&url=" + CGI.escape(@company.factsheet_url) + "&userid=" + (current_user.present? ? current_user.id.to_s : "")
    else
      @show_plan_specifics = false
    end
  end


  def pp_zip_lookup
    zip_lookup(params[:zip]) # sets zip for @cached_visitor and sets @zip
    set_visitor_state(@zip.postal_state) if @zip.present?
    set_home_type(params[:home_type])

    if (params[:company_name]).present? # Submitted From Review Page
      company_name_escaped = CGI.escape(params[:company_name])
      home_type_uri = CGI.escape(params[:home_type])
      if @zip.blank?
          path_company_name = ( (params[:path_company_name]) +
              "?company_name=" + company_name_escaped + "&id=" + (params[:id]) + "&zip=" + (params[:zip]) + "&home_type=" + home_type_uri)
          redirect_to path_company_name
      else
          path_company_name = ( (params[:path_company_name]) +
              "?company_name=" + company_name_escaped + "&zip=" + @zip.zip + "&id=" + (params[:id]) + "&home_type=" + home_type_uri)
          redirect_to path_company_name
      end
      return
    end

    # If Submitted from Company-List Page
    if @zip.blank?
      flash[:notice] = "Zip Not Found"
    end
    redirect_to compare_power_plans_path
  end



  def set_visitor_state(state)
    case
      when (state == 'texas' || state == 'TX')
        @state = 'TX'
      when (state == 'illinois' || state == 'IL')
        @state = 'IL'
    end #case

    @cached_visitor.update_attribute(:postal_state, @state)
  end


  def get_visitor_state
    @state = @cached_visitor.postal_state
  end


  def set_home_type(home_type)
    if home_type.present?
      @cached_visitor.update_attribute(:home_type, home_type)
      @home_type = home_type
    end
  end


  def get_home_type
    @home_type = nil if current_user.present? # sq-ft range here?
    @home_type = @cached_visitor.home_type if @cached_visitor.present?
  end


  def import
    Company.import(params[:file])
    redirect_to compare_power_plans_path, notice: "Company Information Imported."
  end

end
