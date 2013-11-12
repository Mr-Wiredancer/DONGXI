module ProjectHelper
  def render_project_content(project)
  end

  def project_raise_type_options
    ProjectBasicInfo::RAISE_TYPE.collect {|k,v| [v[:description], v[:weight]] }
  end
end
