require 'sqlite3'

require_relative 'database-model.rb'

module Deployment

    # ===== Constant definitions =====
    RESET_SCHEMA_SCRIPT_PATH = "database/reset-schema.sql"
    
    def Deployment.resetDatabase

        # Read in reset schema file as a string.
        resetSchema = "";
        File.open(RESET_SCHEMA_SCRIPT_PATH) do |file|
            file.each_line do |line|
                resetSchema = resetSchema + line;
            end
        end

        # Split string on semicolons so they can be run individually.
        resetQueries = resetSchema.split(';')

        # Run each command to reset the database completely
        resetQueries.each do |query|
            Bookmarks.execute query
        end
    end
end