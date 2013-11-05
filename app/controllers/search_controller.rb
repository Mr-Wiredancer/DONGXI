class SearchController < ApplicationController
  def index
    @projects = Project.search(params)
  end
end
