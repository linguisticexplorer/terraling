class Forum < ApplicationRecord
  
  # Associations
  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics
  
  belongs_to :forum_group
  
  # Scopes
  default_scope { order(position: :asc) }
  
  # Validations
  validates :title,       :presence => true
  validates :description, :presence => true
  validates :forum_group_id, :presence => true
end