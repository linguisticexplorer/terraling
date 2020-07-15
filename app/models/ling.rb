class Ling < ApplicationRecord
  resourcify
  
  include Groupable
  include CSVAttributes

  CSV_ATTRIBUTES = %w[ id name depth parent_id group_id creator_id ]
  def self.csv_attributes
    CSV_ATTRIBUTES
  end

  validates :name, :presence => true, :uniqueness => { :scope => :group_id }
  validates :depth, :presence => true, :numericality => true
  validates :parent, :presence => true, :allow_nil => true
  
  validate :parent_depth_check
  validate :group_association_match
  validate :available_depth_for_group

  # TODO dependent nullify parent_id on child if parent destroyed
  belongs_to :parent, :class_name => "Ling", :foreign_key => "parent_id", :inverse_of => :children
  has_many :children, :class_name => "Ling", :foreign_key => "parent_id", :inverse_of => :parent

  has_many :examples, :dependent => :destroy
  has_many :lings_properties, :dependent => :destroy
  has_many :properties, :through => :lings_properties
  has_many :stored_values, :as => :storable, :dependent => :destroy

  include Concerns::Wheres
  include Concerns::Selects
  include Concerns::Orders

  scope :parent_ids, -> { select("#{self.table_name}.parent_id") }
  scope :with_parent_id, -> (id_or_ids) { where("#{self.table_name}.parent_id IN (:ids)", { ids: id_or_ids }) }

  attr_accessor :info

  def get_infos
    props_in_ling
    self
  end

  def grouped_name
    group.ling_name_for_depth(self.depth || 0)
  end

  def add_property(value, property)
    params = {:property_id => property.id, :value => value}
    unless lings_properties.exists?(params)
      lings_properties.create(params) do |lp|
        lp.group = group
      end
    end
  end
  def add_property_sureness(value, sureness, property)
    params = {:property_id => property.id, :value => value, :sureness => sureness}
    unless lings_properties.exists?(params)
      lings_properties.create(params) do |lp|
        lp.group = group
      end
    end
  end

  def parent_depth_check
    errors.add(:parent, "must be a #{group.ling0_name.humanize} object") if (depth == 1 && parent && parent.depth != 0)
  end

  def group_association_match
    errors.add(:parent, "#{group.ling0_name.humanize} must belong to the same group as this #{self.grouped_name}") if parent && parent.group != group
  end

  def available_depth_for_group
    errors.add(:depth, "is deeper than allowed in #{group.name}") if group && depth && group.depth_maximum < depth
  end

  def storable_keys
    group.present? ? group.ling_storable_keys : []
  end

  def store_value!(key_symbol_or_string, value_string)
    key = key_symbol_or_string.to_s
    if curr = stored_values.with_key(key).first
      curr.value = value_string
      curr.save
    else
      StoredValue.create(:key => key.downcase, :value => value_string, :storable => self)
    end
  end

  def stored_value(key_symbol_or_string)
    key = key_symbol_or_string.to_s
    if storable_keys.include? key
      (record = stored_values.select{|sv| sv.key == key}.first).present? ? record.value : ""
    else
      nil
    end
  end

  def as_json(options={})
    super(:only => [:id, :name, :depth, :parent_id])
  end

  def get_valid_resource
    self
  end

  private

  def props_in_group
    # look for categories at that depth
    cats_at_depth = Category.in_group(group).at_depth(depth)
    # sum up all props in cats
    @props_total ||= Property.in_group(group).where(:category_id => cats_at_depth).count(:id)
  end

  def props_in_ling
    # Rails.logger.debug "[DEBUG] Depth: #{depth} - #{props_in_group} & #{LingsProperty.in_group(group).where(:ling_id => self.id).count(:id)}"
    @info ||= LingsProperty.in_group(group).where(:ling_id => self.id).count(:id) * 100 / (props_in_group > 0 ? props_in_group : 1) 
    @info = 100 if @info > 100
  end

end
