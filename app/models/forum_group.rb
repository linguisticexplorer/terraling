class ForumGroup < ActiveRecord::Base
  
  # Associations
  has_many :forums, :dependent => :destroy
  
  # Scopes
  default_scope { order(position: :asc) }
  
  # Validations
  validates :title,       :presence => true
end