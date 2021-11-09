class Property < ApplicationRecord
  
  include Groupable
  include CSVAttributes

  CSV_ATTRIBUTES = %w[ id name description category_id group_id creator_id ]
  def self.csv_attributes
    CSV_ATTRIBUTES
  end

  validates :name, :presence => true, :uniqueness => { :scope => :group_id }
  validates :category, :presence => true
  validate :group_association_match

  belongs_to :category
  belongs_to :creator, :class_name => "User"
  belongs_to :team, :class_name => "Team"
  has_many :lings_properties, :dependent => :destroy

  include Concerns::Selects
  include Concerns::Wheres
  include Concerns::Orders

  # override
  scope :at_depth, -> (depth) { joins(:category).where(categories: {depth: depth}) }

  def depth
    category.depth
  end

  def available_values
    lings_properties.map {|lp| lp.value.downcase.strip }.uniq
  end

  def group_association_match
    errors.add(:category, "#{group.category_name.humanize} must belong to the same group as this #{group.property_name}") if group && category && category.group != group
  end

  attr_reader :info

  def get_infos
    lings_in_prop
    self
  end

  def get_valid_resource
    false
  end

  def as_json(options={})
    super(:only => [:id, :name, :category_id])
  end

  private

  def lings_in_group
    @lings_total ||= Ling.in_group(group).count(:id)
    @lings_total > 0 ? @lings_total : 1
  end

  def lings_in_prop
    @info ||= LingsProperty.in_group(group).where(:property_id => self.id).count(:id) * 100 / lings_in_group
    @info = 100 if @info > 100
  end

end
