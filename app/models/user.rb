class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:facebook]
 	belongs_to :zip
  belongs_to :visitor
  belongs_to :customer_usage

 	has_many :bills
 	#accepts_nested_attributes_for :bills

  has_many :transactions

  belongs_to :referred_by, class_name: 'User', foreign_key: 'referred_by_id'

 	validates :email, :plan_type, :zip_id, presence: true
  # validates :email, :first_name, :last_name, :phone, :plan_type, :zip_id, presence: true
  #validates_presence_of :plan_grade, message: "Please Select An Energy Source Preference"
 	validates_uniqueness_of :email

  attr_encrypted :ssnum, :key => 'testingkey'

  #TODO real key-value will be stored in the server

  def create_stripe_subscription(card_details)
    @error = ""
		begin
			customer = Stripe::Customer.create(
				:email => self.email,
		 		## if you are using the js to fetch the stripe_card_token change the ':card => card_details["stripe_card_token"]' ##
		 		:card => {
		 			:number => card_details["card_number"],
		 			:exp_month => card_details["exp_month"],
		 			:exp_year => card_details["exp_year"],
		 			:cvc => card_details["cvc"]
        },
			  :plan => card_details["plan_id"]
      )

   		puts "==Customer_id : ====#{customer.id}============"
      puts "--------------User Model Stripe Customer Object: " + customer.inspect
      @transaction = Transaction.new( :user_id => self.id,
                                      :payment_service => "Stripe",
                                      :trans_type => "CreateStripeCustomer",
                                      :stripe_id => customer.id,
                                      :last4 => customer.cards.data.first['last4'],
                                      :brand => customer.cards.data.first['brand'],
                                      :funding => customer.cards.data.first['funding'],
                                      :exp_month => customer.cards.data.first['exp_month'],
                                      :exp_year => customer.cards.data.first['exp_year']
                                    )
       unless @transaction.save
         puts "-----UserModel - Stripe - Our Transaction Did Not Save on Stripe Fail"
       end

	 	rescue Stripe::StripeError => e
       logger.warn("====#{e.message}==")
       puts "====User-Model - Stripe Transaction Failed Due to #{e.message}====="
       @error = ("card error: " + e.message)
      # Transaction Error Record Created In Controller
      #  @transaction = Transaction.new( :user_id => self.id,
      #                                  :payment_service => "Stripe",
      #                                  :trans_type => "Failed",
      #                                  :stripe_callback_data => @error
      #                                )
        # unless @transaction.save
        #   puts "-----UserModel - Stripe - Our Transaction Did Not Save on Stripe Fail"
        # end
		end
		return @error

  end # create_stripe_subscription


  def self.from_omniauth(auth)
    #where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    where(email: auth.info.email).first do |user|
      if user.present?
        puts "---------- UserModel-Onmiauth: Found User via email-match"
        # Will get location here
        # user.update_column(:provider, auth.provider) unless user.provider.present?
        # user.update_column(:uid, auth.uid) unless user.uid.present?
      else
        puts "---------- UserModel-Onmiauth: NOT Found User via email-match - setting up sign-up form"
        @cached_visitor.update_column(:first_name, auth.info.first_name) if auth.info.first_name.present?
        @cached_visitor.update_column(:last_name, auth.info.last_name) if auth.info.last_name.present?
        @cached_visitor.update_column(:email, auth.info.email) if auth.info.email.present?
        # these will be auto-populated on sign-up form
        # facebook does not provide a 'phone'
        # https://developers.facebook.com/docs/graph-api/reference/v2.0/user
        puts "----------This is All Info Available from FB..."
        puts "----------Facebook Callback Data: " + env["omniauth.auth"].to_s
      end
    end
  end

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "Shave<br>Cream",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("refer/cream-tooltip@2x.png")
        },
        {
            'count' => 10,
            "html" => "Truman Handle<br>w/ Blade",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("refer/truman@2x.png")
        },
        {
            'count' => 25,
            "html" => "Winston<br>Shave Set",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("refer/winston@2x.png")
        },
        {
            'count' => 50,
            "html" => "One Year<br>Free Blades",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
        }
    ]

end #class
