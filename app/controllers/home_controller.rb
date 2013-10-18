class HomeController < ApplicationController
  def index
    @profile = Profile.first # TODO: latest? several?
  end
end
