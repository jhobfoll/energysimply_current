SimplyElectricity::Application.routes.draw do

  resources :customer_usages

    # scope :constraints => {:subdomain => "api"} do
    namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        scope '/savings_calculator_api' do
          get '/savings_tdu_list' => 'savings_calculator_api#savings_tdu_list', as: 'savings_tdu_list'
        end
      end # namespace v1
    end # namespace :api
   # end # api.energysimp.ly
   # Example Call to API (get request)
   # energysimp.ly/api/v1/savings_calculator_api/savings_tdu_list?calculator_zip=77001&calculator_bill_month=10&calculator_bill_mo_cost=100&calculator_bill_kwh=1000


  resources :click_trackings

  resources :transactions, except: [:destroy]

  # post '/users/sign_in' => "devise/sessions#new", as: :sign_in_path
  devise_for :users, :controllers => { :registrations => "registrations",
									   :sessions => "sessions",
                     :omniauth_callbacks => "omniauth_callbacks"
									 }

  resources :bills

  resources :tdus

  get "home_zip_submission" => "pages#home_zip_submission", as: :home_zip_submission

  resources :savings_calculator_data, except: [:show] do
    collection { post :import }
  end
  get "savings_calculator" => "savings_calculator_data#savings_calculator", as: :savings_calculator
  post "savings_calculator" => "savings_calculator_data#savings_calculator_calculate", as: :savings_calculator_calculate

  scope '/users' do
    #get "choose_plan" => "users#choose_plan", as: :choose_plan
    #post "choose_plan_update" => "users#choose_plan_update", as: :choose_plan_update
    get "payment" => "users#payment", as: :payment
    get "submit_bill" => "users#submit_bill", as: :submit_bill
    patch "submit_bill_update" => "users#submit_bill_update", as: :submit_bill_update
    get "refer-a-friend" => "users#refer", as: :refer
  end

  resources :users, except: [:new, :create]

  get "users" => "pages#users"

  #scope '/paypal' do
   # match "success" => "paypal#paypal_success", via: [:get, :post], as: :paypal_success
   # match "failure" => "paypal#paypal_failure", via: [:get, :post], as: :paypal_failure
   # match "notify" => "paypal#paypal_notify", via: [:get, :post], as: :paypal_notify
  #end

  scope '/stripe_charges' do
    post "create" => "stripe_charges#create", as: :stripe_create
    get "stripe_config" => "stripe_charges#stripe_config", as: :stripe_config
    post "create_plans" => "stripe_charges#create_plans", as: :create_plans
  end

  scope '/email_refs' do
    get '/check_email' => 'email_refs#check_email'
    put '/create_email_ref' => 'email_refs#create_email_ref', as: 'create_email_ref'
  end
  resources :email_refs

  root :to => 'pages#home', as: :root

  get "thankyou" => "pages#thankyou", as: :thank_you

  get "cheapest-electric" => "pages#cheapest_electric", as: :cheapest_electric

  get "texas-plans" => "pages#texas_plans", as: :texas_plans

  get "tx-plans" => "pages#tx_plans", as: :tx_plans

  get "cheap-plans" => "pages#cheap_plans", as: :cheap_plans

  get "power-to-choose" => "pages#power_to_choose", as: :power_to_choose

  get "electric-companies" => "pages#electric_companies", as: :electric_companies

  get "renewable-power" => "pages#renewable_power", as: :renewable_power

  get "energy-simply-team" => "pages#energy_simply_team", as: :energy_simply_team

  get "about_energy_simply" => "pages#about_energy_simply"

  get "jobs" => "pages#jobs"

  get "how-it-works" => "pages#how_it_works", as: :how_it_works

  get "locations" => "pages#locations"

  get "our_mission" => "pages#our_mission"

  get "testimonials" => "pages#benefits_and_testimonials", as: :benefits_and_testimonials

  get "terms" => "pages#terms_of_use", as: :terms_of_use

  get "save-energy-and-money-store" => "pages#save_energy_and_money_store"

  get "contact_us" => "pages#contact_us", as: :contact_us
  post "contact_us" => "pages#contact_us_submit", as: :contact_us_submit

  scope '/compare-power-plans' do
    get "texas" => "compare_power_plans#compare_power_plans", as: :compare_power_plans_tx
    get "illinois" => "compare_power_plans#compare_power_plans", as: :compare_power_plans_il
    get "" => "compare_power_plans#compare_power_plans", as: :compare_power_plans
    post "import_company_rankings" => "compare_power_plans#import", as: :import_company_rankings
    post "pp_zip_lookup" => "compare_power_plans#pp_zip_lookup", as: :pp_zip_lookup
	  match '*path' =>  "compare_power_plans#review", via: [:get], as: :energy_company_review
  end


  scope '/offsite-click' do
    match '*path' =>  "click_trackings#create", via: [:get], as: :click_track
  end

  get "sitemap.xml" => "pages#sitemap", as: "sitemap", defaults: { format: "xml" }


  # match "/Zrfy1", to: redirect('/?referral_key=Zrfy1'), via: [:get], as: :referral_to_signup
  match "/Z:key_wild", to: redirect('/?referral_key=Z%{key_wild}'), via: [:get], as: :referral_to_signup
  match "/Y:key_wild", to: redirect('/?referral_key=Y%{key_wild}'), via: [:get], as: :referral_to_signup_y


  #404 redirects

  match '/energy-company-rankings' => redirect('/compare-power-plans'), via: [:get]
  match '/energy-company-rankings/4change-energy' => redirect('/compare-power-plans/4change-energy'), via: [:get]
  match '/energy-company-rankings/acacia-energy' => redirect('/compare-power-plans/acacia-energy'), via: [:get]
  match '/energy-company-rankings/ambit-energy' => redirect('/compare-power-plans/ambit-energy'), via: [:get]
  match '/energy-company-rankings/american-light-and-power' => redirect('/compare-power-plans/american-light-and-power'), via: [:get]
  match '/energy-company-rankings/amigo-energy' => redirect('/compare-power-plans/amigo-energy'), via: [:get]
  match '/energy-company-rankings/ap-gas-and-electric' => redirect('/compare-power-plans/ap-gas-and-electric'), via: [:get]
  match '/energy-company-rankings/beyond-power' => redirect('/compare-power-plans/beyond-power'), via: [:get]
  match '/energy-company-rankings/bounce-energy' => redirect('/compare-power-plans/bounce-energy'), via: [:get]
  match '/energy-company-rankings/breeze-energy' => redirect('/compare-power-plans/breeze-energy'), via: [:get]
  match '/energy-company-rankings/brilliant-energy' => redirect('/compare-power-plans/brilliant-energy'), via: [:get]
  match '/energy-company-rankings/champion-energy' => redirect('/compare-power-plans/champion-energy'), via: [:get]
  match '/energy-company-rankings/cirro-energy' => redirect('/compare-power-plans/cirro-energy'), via: [:get]
  match '/energy-company-rankings/clearview-energy' => redirect('/compare-power-plans/clearview-energy'), via: [:get]
  match '/energy-company-rankings/compassion-energy' => redirect('/compare-power-plans/compassion-energy'), via: [:get]
  match '/energy-company-rankings/conservice-energy' => redirect('/compare-power-plans/conservice-energy'), via: [:get]
  match '/energy-company-rankings/cpl-retail-energy' => redirect('/compare-power-plans/cpl-retail-energy'), via: [:get]
  match '/energy-company-rankings/direct-energy' => redirect('/compare-power-plans/direct-energy'), via: [:get]
  match '/energy-company-rankings/discount-power' => redirect('/compare-power-plans/discount-power'), via: [:get]
  match '/energy-company-rankings/enertrade-electric' => redirect('/compare-power-plans/enertrade-electric'), via: [:get]
  match '/energy-company-rankings/entrust-energy' => redirect('/compare-power-plans/entrust-energy'), via: [:get]
  match '/energy-company-rankings/everything-energy' => redirect('/compare-power-plans/everything-energy'), via: [:get]
  match '/energy-company-rankings/first-choice-power' => redirect('/compare-power-plans/first-choice-power'), via: [:get]
  match '/energy-company-rankings/frontier-utilities' => redirect('/compare-power-plans/frontier-utilities'), via: [:get]
  match '/energy-company-rankings/gexa-energy' => redirect('/compare-power-plans/gexa-energy'), via: [:get]
  match '/energy-company-rankings/green-mountain-energy' => redirect('/compare-power-plans/green-mountain-energy'), via: [:get]
  match '/energy-company-rankings/igs-energy' => redirect('/compare-power-plans/igs-energy'), via: [:get]
  match '/energy-company-rankings/infinite-energy' => redirect('/compare-power-plans/infinite-energy'), via: [:get]
  match '/energy-company-rankings/just-energy' => redirect('/compare-power-plans/just-energy'), via: [:get]
  match '/energy-company-rankings/kona-energy' => redirect('/compare-power-plans/kona-energy'), via: [:get]
  match '/energy-company-rankings/nec-retail' => redirect('/compare-power-plans/nec-retail'), via: [:get]
  match '/energy-company-rankings/new-leaf-energy' => redirect('/compare-power-plans/new-leaf-energy'), via: [:get]
  match '/energy-company-rankings/our-energy' => redirect('/compare-power-plans/our-energy'), via: [:get]
  match '/energy-company-rankings/pennywise-power' => redirect('/compare-power-plans/pennywise-power'), via: [:get]
  match '/energy-company-rankings/power-house-energy' => redirect('/compare-power-plans/power-house-energy'), via: [:get]
  match '/energy-company-rankings/reliant-energy' => redirect('/compare-power-plans/reliant-energy'), via: [:get]
  match '/energy-company-rankings/smart-prepaid-electric' => redirect('/compare-power-plans/smart-prepaid-electric'), via: [:get]
  match '/energy-company-rankings/source-power-and-gas' => redirect('/compare-power-plans/source-power-and-gas'), via: [:get]
  match '/energy-company-rankings/southwest-power-and-light' => redirect('/compare-power-plans/southwest-power-and-light'), via: [:get]
  match '/energy-company-rankings/spark-energy' => redirect('/compare-power-plans/spark-energy'), via: [:get]
  match '/energy-company-rankings/startex-power' => redirect('/compare-power-plans/startex-power'), via: [:get]
  match '/energy-company-rankings/stream-energy' => redirect('/compare-power-plans/stream-energy'), via: [:get]
  match '/energy-company-rankings/summer-energy' => redirect('/compare-power-plans/summer-energy'), via: [:get]
  match '/energy-company-rankings/tara-energy' => redirect('/compare-power-plans/tara-energy'), via: [:get]
  match '/energy-company-rankings/texpo-energy' => redirect('/compare-power-plans/texpo-energy'), via: [:get]
  match '/energy-company-rankings/trieagle-energy' => redirect('/compare-power-plans/trieagle-energy'), via: [:get]
  match '/energy-company-rankings/trusmart-energy' => redirect('/compare-power-plans/trusmart-energy'), via: [:get]
  match '/energy-company-rankings/txu-energy' => redirect('/compare-power-plans/txu-energy'), via: [:get]
  match '/energy-company-rankings/v247-power' => redirect('/compare-power-plans/v247-power'), via: [:get]
  match '/energy-company-rankings/veteran-energy' => redirect('/compare-power-plans/veteran-energy'), via: [:get]
  match '/energy-company-rankings/wtu-retail-energy' => redirect('/compare-power-plans/wtu-retail-energy'), via: [:get]
  match '/energy-company-rankings/yep-energy' => redirect('/compare-power-plans/yep-energy'), via: [:get]
  match '/energy-company-rankings/hino-electric-power-company' => redirect('/compare-power-plans/hino-electric-power-company'), via: [:get]


  # resources :pins

    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
