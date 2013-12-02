class Ability
  include CanCan::Ability

  # :manage => all
  # :read => :index & :show
  # :update => :edit & :update
  # :destroy => :destroy
  # :create => :new & :create

  def initialize(user)

    if user.blank?
      cannot :manage, :all
      basic_read_only
    elsif user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:member)
      basic_read_only
      # projects
      alias_action :preview, :submit, :update, :destroy, :to => :manage_own
      alias_action :donate, :add_volunteer, :remove_volunteer, :to => :support
      can :support, Project, :status => 2 # published
      can :create, Project
      can :manage_own, Project do |p|
        p.user_id == user.id && p.in_edit?
      end
    else
      cannot :manage, :all
      basic_read_only
    end
  end

  def basic_read_only
    can :read, Project, :status => 2 # published
  end
end
