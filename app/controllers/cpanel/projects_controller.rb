# coding: utf-8
class Cpanel::ProjectsController < Cpanel::ApplicationController
	def index
		@projects = Project.all
	end
end