class HomeController < ApplicationController
  def index
    @project = Project.first
  end

end
