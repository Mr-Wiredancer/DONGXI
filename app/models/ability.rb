class Ability
  include CanCan::Ability

  # :manage => all
  # :read => :index & :show
  # :update => :edit & :update
  # :destroy => :destroy
  # :create => :new & :create

  def initialize(user)

    alias_action :show, :update, :destroy, :to => :manage_single

    if user.blank?
      cannot :manage, :all
      basic_read_only
    elsif user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:member)
      # projects
      can :manage_single, Project do |project|
        project.user_id == user.id
      end
      can :create, Project

      can :manage_single, User, id: user.id

    else
      cannot :manage, :all
      basic_read_only
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def basic_read_only
    can :read, Project
  end
end
