module Groupable
  def self.included(base)
    base.validates :group, :presence => true
    base.validates :creator, :presence => true, :allow_nil => true
    base.belongs_to :group
    base.belongs_to :creator, :class_name => "User"
  end
end
