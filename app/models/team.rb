class Team < ApplicationRecord
    include CSVAttributes
  
    CSV_ATTRIBUTES = %w[ id name information primary_author_id ]
    def self.csv_attributes
      CSV_ATTRIBUTES
    end

    validates_presence_of :name, :website

    def primary_author
        if self.primary_author_id
            User.find(self.primary_author_id)
        else
            nil
        end
    end

end