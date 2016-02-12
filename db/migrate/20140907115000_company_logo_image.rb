class CompanyLogoImage < ActiveRecord::Migration
  def change
    add_column :companies, :logo_image, :string
  end
end
