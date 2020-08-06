class Team < ApplicationRecord
    include CSVAttributes
  
    CSV_ATTRIBUTES = %w[ id name information primary_author_id ]
    def self.csv_attributes
      CSV_ATTRIBUTES
    end

end