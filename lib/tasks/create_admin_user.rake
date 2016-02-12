# run this with 'rake create_admin_user'


desc "Create Admin User"
task create_admin_user: :environment do
  admin = User.create!(first_name: "Admin",
               last_name: "User",
               email: "admin@energysimp.ly",
               password: "k1a7Ushmz317ME0w",
               password_confirmation: "k1a7Ushmz317ME0w",
               zip_id: "1")
  admin.toggle!(:admin)

end
