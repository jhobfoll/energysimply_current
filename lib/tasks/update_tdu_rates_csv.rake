# run this with ' rake update_tdu_rates' 

require 'csv'

desc "Imports TDU Rate Updates From CSV file into 'tdus' Table"

# task :update_tdu_rates => :environment do
# specify the file-name/location from the command-line
task(:update_tdu_rates, [:filename] => :environment) do |t, args|
  args.with_default(:filename => :environment)
  puts "args_Inspect -  #{args.inspect}"
  puts "Filename - #{args['filename']}"

  unless ("#{args['filename']}").present?
    puts "Filename Required.  Run this with: rake update_tdu_rates[/path/to/file]"
    exit
  end # filename given test

  #  filename = '/tmp/tdu_rate_updates.csv'
    @filename = "#{args['filename']}"

    CSV.foreach(@filename, :headers => true) do |row|
      @tdu_source_line = (row.to_hash)

        puts "TEST --- tdu source line: " + @tdu_source_line.inspect

        # work in rails, but not ruby-script
        # puts "TEST2 --- element: " + @tdu_source_line[:TDU] + " - "
        # puts "TEST2 --- element: " + @tdu_source_line['TDU'] + " - "

        # ruby syntax works
        # puts 'TEST2 --- element: ' + "#{@tdu_source_line['TDU']}" + " - "

        @tdu_name = "#{@tdu_source_line['TDU']}"
        puts 'Update TDU Rates --- Source Line Name: ' + @tdu_name

        case @tdu_name

        when "AEP TEXAS CENTRAL COMPANY"
          @tdu_row = Tdu.where('name = ?', 'AEP TEXAS CENTRAL COMPANY').first

        when "AEP TEXAS NORTH COMPANY"
          @tdu_row = Tdu.where('name = ?', 'AEP TEXAS NORTH COMPANY').first

        when "CENTERPOINT ENERGY HOUSTON ELECTRIC LLC"
          @tdu_row = Tdu.where('name = ?', 'CENTERPOINT ENERGY HOUSTON ELECTRIC LLC').first

        when "AEP TEXAS NORTH COMPANY"
          @tdu_row = Tdu.where('name = ?', 'AEP TEXAS NORTH COMPANY').first

        when "SHARYLAND UTILITIES LP"
          @tdu_row = Tdu.where('name = ?', 'SHARYLAND UTILITIES LP').first

        when "SHARYLAND UTILITIES LP - MCALLEN"
          @tdu_row = Tdu.where('name = ?', 'SHARYLAND UTILITIES LP - MCALLEN').first

        when "TEXAS-NEW MEXICO POWER COMPANY"
          @tdu_row = Tdu.where('name = ?', 'TEXAS-NEW MEXICO POWER COMPANY').first

        when "COMMONWEALTH EDISON"
          @tdu_row = Tdu.where('name = ?', 'COMMONWEALTH EDISON').first

        # no else - leave null

        end #case

        if @tdu_row.present?
          @tdu_row.apt_avg = "#{@tdu_source_line['Average_Apartment_Plan']}"
          @tdu_row.apt_best = "#{@tdu_source_line['Best_Apartment_Plan']}"
          @tdu_row.house_avg =  "#{@tdu_source_line['Average_House_Plan']}"
          @tdu_row.house_best = "#{@tdu_source_line['Best_House_Plan']}"
        else
          puts "TDU Row With This Name Not Found: " + @tdu_name
        end

        puts 'Update TDU Rates --- record-to-save: ' + @tdu_row.inspect

        unless @tdu_row.save
          puts "Error Saving TDU Update for: " + @tdu_row.name.to_s +
                " from csv-line: " + @tdu_name
        end # unless save

      end # each do

  end #def
