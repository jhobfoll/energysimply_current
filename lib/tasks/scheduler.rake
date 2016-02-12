
# run with 'rake set_tdu_id'
desc "Task to Set / Update Zip.tdu_id from tdu_name value"
task :set_tdu_id  => :environment do
  puts "Updating tdu_id in Zips table ..."
  Zip.set_tdu_id
  puts "Done Updating tdu_id in Zips table."
end

