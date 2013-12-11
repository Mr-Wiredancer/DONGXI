# coding: utf-8
module ProjectHelper
  ### name
  def render_project_name(project)
    name = @project.name.blank? ? "暂无名称" : project.name
    owner = project.owner_name.blank? ? "暂无团队名称" : "由#{project.owner_name}发起"
    output = content_tag("h1", name) + content_tag(:p, owner)
    output
  end

  ### story & info
  def render_story_and_info(project)
    output = ""
    output = output + render_project_photo(project) + render_project_video(project) + render_project_introduction(project)
    output.html_safe
  end
  def render_project_video(project)
    project.video_url ? content_tag(:div, raw(project.video_url), class: "video row") : ""
  end
  def render_project_introduction(project)
    project.introduction ? content_tag(:div, raw(project.introduction), class: 'description row') : ""
  end
  def render_project_photo(project)
    project.photo ? image_tag(project.photo.url(:normal)) : ""
  end

  ### progress
  def render_progress_bar(progress, target)
    percentage = if target == 0
                  0
                elsif progress == target
                  100
                else
                  (progress.to_f / target.to_f * 100).to_i
                end
    content_tag :div, class: "progress-bar" do
      render_speed(percentage)
    end
  end

  ### SNS
  def render_project_weibo(project)
    project.weibo_status ? render_weibo_status(project.weibo_status.status_id) + render_weibo_share(project) : ""
  end
  def render_weibo_status(sid)
    content_tag :div, class: 'row' do
      render :partial => "common/weibo_status", locals: { id: sid }
    end
  end
  def render_weibo_share(project)
    content_tag :div, class: 'row' do
      render  :partial => "common/weibo_share_button",
              :locals  => {
                :url      => request.original_url,
                :pic_url  => "http%3A%2F%2Fstatic.youku.com%2Findex%2Fimg%2Fheader%2Fyklogo.png",
                :tag      => "东西科技", # slogan?
                :text     => project.try(:basic_info).try(:name),
                :mid      => project.weibo_status.status_mid,
              }
    end
  end

  ### others
  def render_project_weibo_meta(project)
    render :partial => "weibo_meta", locals: { project: project }
  end

  def project_raise_type_options
    ProjectBasicInfo::RAISE_TYPE.collect {|k,v| [v[:description], v[:weight]] }
  end

  private


  def render_speed(percentage)
    flag = percentage >= 100 ? "success" : ""
    content_tag :span, nil, class: "speed #{flag}", style:"width: #{percentage}%"
  end

end
