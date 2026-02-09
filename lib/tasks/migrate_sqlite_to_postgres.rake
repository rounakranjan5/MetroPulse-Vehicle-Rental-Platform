namespace :db do
  desc "Migrate data from SQLite to PostgreSQL"
  task migrate_from_sqlite: :environment do
    require 'sqlite3'
    
    # Path to your SQLite database
    sqlite_db_path = Rails.root.join('storage', 'development.sqlite3')
    
    unless File.exist?(sqlite_db_path)
      puts "❌ SQLite database not found at: #{sqlite_db_path}"
      exit 1
    end
    
    puts "🔄 Starting data migration from SQLite to PostgreSQL..."
    puts "📁 SQLite database: #{sqlite_db_path}"
    puts ""
    
    # Connect to SQLite
    sqlite_db = SQLite3::Database.new(sqlite_db_path)
    sqlite_db.results_as_hash = true
    
    # Define migration order to respect foreign key constraints
    # Parent tables must be migrated before child tables
    migration_order = [
      'users',
      'rental_stations', 
      'vehicles',
      'bookings',
      'payments'
    ]
    
    # Get all other tables not in the specific order
    all_tables = sqlite_db.execute(
      "SELECT name FROM sqlite_master WHERE type='table' 
       AND name NOT LIKE 'sqlite_%' 
       AND name NOT LIKE 'ar_internal_%'
       AND name != 'schema_migrations'
       AND name != 'ar_internal_metadata'
       ORDER BY name"
    ).map { |row| row['name'] }
    
    # Add any remaining tables not in the specific order
    other_tables = all_tables - migration_order
    tables_to_migrate = migration_order + other_tables
    
    # Disable foreign key checks temporarily
    ActiveRecord::Base.connection.execute("SET session_replication_role = 'replica';")
    
    begin
      tables_to_migrate.each do |table_name|
        next unless all_tables.include?(table_name)
        
        begin
          # Get the model class if it exists
          model_class = table_name.classify.constantize rescue nil
          
          if model_class && model_class < ActiveRecord::Base
            # Get data from SQLite
            rows = sqlite_db.execute("SELECT * FROM #{table_name}")
            
            if rows.empty?
              puts "⏭️  #{table_name}: No data to migrate"
              next
            end
            
            puts "📦 Migrating #{table_name}: #{rows.length} records..."
            
            # Get column names from first row
            columns = rows.first.keys
            
            # Insert each row
            migrated_count = 0
            rows.each do |row|
              # Convert row hash to use only the columns that exist in the model
              attributes = {}
              columns.each do |col|
                attributes[col] = row[col] if model_class.column_names.include?(col)
              end
              
              # Create record without validations and callbacks for faster import
              record = model_class.new(attributes)
              record.save(validate: false)
              migrated_count += 1
            end
            
            # Reset the sequence for the id column
            if model_class.column_names.include?('id')
              max_id = model_class.maximum(:id) || 0
              sequence_name = "#{table_name}_id_seq"
              ActiveRecord::Base.connection.execute(
                "SELECT setval('#{sequence_name}', #{max_id + 1}, false)"
              ) rescue nil
            end
            
            puts "✅ #{table_name}: Migrated #{migrated_count} records"
            
          else
            puts "⚠️  #{table_name}: No model found, skipping..."
          end
          
        rescue => e
          puts "❌ Error migrating #{table_name}: #{e.message}"
          puts "   #{e.backtrace.first}"
        end
        
        puts ""
      end
    ensure
      # Re-enable foreign key checks
      ActiveRecord::Base.connection.execute("SET session_replication_role = 'origin';")
    end
    
    sqlite_db.close
    
    puts "🎉 Migration completed!"
    puts ""
    puts "📊 Summary:"
    puts "   Users: #{User.count}"
    puts "   Rental Stations: #{RentalStation.count}"
    puts "   Vehicles: #{Vehicle.count}"
    puts "   Bookings: #{Booking.count}"
    puts "   Payments: #{Payment.count}"
  end
end
