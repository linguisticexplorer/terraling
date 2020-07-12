module Concerns
  module Wheres
    def self.included(base)
      base.class_exec do
        scope :in_group, -> (group) { where( group_id: group.id ) }
        scope :at_depth, -> (depth) { where( depth: depth ) }
      end
    end
  end
end
