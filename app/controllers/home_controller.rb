class HomeController < ApplicationController
  def index
    @projects = Project.published.first(4)
  end

end
