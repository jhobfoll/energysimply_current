# run with 'rake zip_update_tdu_names'
# put csv called 'zip_tdu_update.csv' in "/db" folder containing 2 columns.
# This should be added and pushed to Heroku, then run  via heroku run rake ...
# header in csv is mandatory - should be "zip" "tdu_name" for the 2 columns

require 'csv'

desc "Update tdu_name in zip table for new tdus"

task :zip_update_tdu_names => :environment do

  @filename = Rails.root.join.to_s + '/db/zip_tdu_update.csv'

  puts "------Rails.root is: " + (Rails.root).to_s
  puts "------the Filename is: " + @filename.to_s

    CSV.foreach(@filename, :headers => true) do |row|
      @zip_tdu_source_line = (row.to_hash)

        puts "--- zip-tdu_name source line: " + @zip_tdu_source_line.inspect

        # ruby syntax works for this
        # puts 'TEST2 --- element: ' + "#{@tdu_source_line['TDU']}" + " - "

        @zip_code = "#{@zip_tdu_source_line['zip']}"
        puts ' --- zip element: ' + @zip_code

        @zip_tdu_name = "#{@zip_tdu_source_line['tdu_name']}"
        puts ' --- tdu_name element: ' + @zip_tdu_name

        # Find / Verify the tdu_name exists in the tdus table
        @tdu = Tdu.where('name = ?', @zip_tdu_name).first

        if @tdu.blank?
          puts "New TDU Found for Zip: " + @zip_code

          @tdu = Tdu.new(name: @zip_tdu_name)
          unless @tdu.save
              puts "New TDU Create Failed for: " + @zip_tdu_name +
                " For Zip: " + @zip_code
              return
          else
            puts "New TDU Created: " + @tdu.inspect
          end

        end

        @zip_record = Zip.where('zip = ?', @zip_code).first

        if @zip_record.present?
            @zip_record.tdu_name = @zip_tdu_name
            @zip_record.tdu_id = @tdu.id
            puts '--- record-to-save: ' + @zip_record.inspect

            unless @zip_record.save
              puts "Error Saving tdu_name Update for zip row: " + @zip_record.inspect +
                    " for zip: " +  @zip_code + " for tdu record: " + @tdu.inspect
            end # unless save zip_record ok

        elsif
          puts "Zip Record Not Found For Zip Code: " + @zip_code
        end # if zip-record present


      end # each do

  end #def
