class User < ApplicationRecord
  include CSVAttributes
  include Humanizer

  ACCESS_LEVELS = [
      ADMIN = "admin",
      USER  = "user",
      NEW_USER  = "new_user"
  ]

  CSV_ATTRIBUTES = %w[ id name email access_level password ]
  def self.csv_attributes
    CSV_ATTRIBUTES
  end

  attr_accessor :bypass_humanizer
  
  #TODO: Remove this trick 
  # Until we migrate to rspec 2.6, use this trick...
  # if Rails.env.production?
  #   require_human_on :create, :unless => :bypass_humanizer
  # end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :email, :access_level
  validate :website_must_be_url

  def website_must_be_url
    if (!website.present? || !(website =~ URI::regexp) ) and !id.present?
      errors.add(:website, "must be a valid URL. Please give the URL address of your university, your department, or of your personal website.")
    end
  end

  has_many :memberships, :foreign_key => :member_id, :dependent => :destroy
  has_many :searches, :foreign_key=> :creator_id, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :topics, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :user_teams
  has_many :teams, :through => :user_teams

  scope :new_user, -> { where( :access_level => NEW_USER ) }
  scope :not_new_user, -> { where( :access_level => [USER, ADMIN] ) }

  def admin?
    ADMIN == self.access_level
  end

  def administrated_groups
    self.memberships.select{ |m| m.group_admin? }.map(&:group)
  end

  def reached_max_search_limit?(group)
    Search.reached_max_limit?(self, group)
  end

  def member_of?(group)
    group.is_a?(Group) && group_ids.include?(group.id)
  end

  def group_admin_of?(group)
    group.membership_for(self).try(:group_admin?)
  end

  def is_expert_of?(resource)
    return true if admin?
    ling, group = get_ling_and_group resource
    return true if self.group_admin_of?(group)

    # resource_ids_for_role :resource_expert, resource
    if ling && member_of?(group) && is_expert?(group)

      # is thruthy if is assigned to that resource
      # It is no more necessary to see if there are not experts for that ling
      is_expert = group.membership_for(self).has_role?(:expert, ling)
      is_expert_of_parent = group.membership_for(self).has_role?(:expert, ling.parent)

      return is_expert || is_expert_of_parent
    end

  end

  # This method return true or false if the user can see or not the item.
  # It useful in that part of html that you want to show at user something if the user can see it.
  # It's almost the same thing with is_expert? method but for example:
  # an expert user can see the button for deleting a ling, but he cannot perform the action.
  # In this case is_expert_to_see? has to be true and is_expert? has to be false
  def is_expert_to_see?(action, item, can_user_perform_the_action)
    ling, group = get_ling_and_group item
    if admin? || self.group_admin_of?(group)
      can_user_perform_the_action
    else
      if ling && member_of?(group) && is_expert?(group)
        is_expert = group.membership_for(self).has_role?(:expert, ling)
        is_expert_of_parent = group.membership_for(self).has_role?(:expert, ling.parent)
        # if the user is an expert member, he can see the create ling action icon also if he has not been assigned to that ling
        is_expert || is_expert_of_parent || action == :create
      else
        can_user_perform_the_action
      end
    end
  end

  def is_expert?(group)
    group.membership_for(self).try(:is_expert?)
  end

  def is_expert_for_groups
    [].tap do |entry|
      memberships.each do |membership|
        entry << membership.group.id if membership.is_expert?
      end
    end
  end

  def fake_password

  end

  def get_access_levels
    ACCESS_LEVELS
  end

  def as_json(options={})
    super(:only => [:id, :name, :email])
  end




  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

  private

  def get_ling_and_group(resource)

    # # get referenced Ling
    # ling = resource.is_a?(Ling) ? resource : 
    #        resource.try(:ling)
    # valid_type = [Ling, LingsProperty, ExamplesLingsProperty]
    # valid_resource = resource.is_a?(*valid_type) ? resource.get_valid_resource : false
    # [valid_resource, resource.is_a?(Group) ? resource : resource.group]
    [resource.get_valid_resource || false, resource.is_a?(Group) ? resource : resource.group]
  end

end
