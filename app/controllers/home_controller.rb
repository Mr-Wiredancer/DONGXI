class HomeController < ApplicationController
  def index
    @projects = Project.in_publish.first(4)
  end

end
