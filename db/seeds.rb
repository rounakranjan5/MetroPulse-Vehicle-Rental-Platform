# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Load production seed data from SQL export
if Rails.env.production?
  puts "🌱 Seeding production database from export..."
  
  sql_file = File.join(Rails.root, 'db', 'production_seed_data.sql')
  
  if File.exist?(sql_file)
    sql = File.read(sql_file)
    # Remove lines that will cause issues in production
    sql = sql.gsub(/\\restrict.*\n/, '')
    sql = sql.gsub(/\\unrestrict.*\n/, '')
    
    # Execute the SQL
    ActiveRecord::Base.connection.execute(sql)
    
    puts "✅ Production data seeded successfully!"
    puts "   - #{User.count} users"
    puts "   - #{RentalStation.count} rental stations"
    puts "   - #{Vehicle.count} vehicles"
  else
    puts "⚠️  Seed file not found: #{sql_file}"
  end
else
  puts "Skipping seed in #{Rails.env} environment"
end
