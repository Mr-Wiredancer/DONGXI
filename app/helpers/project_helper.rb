# coding: utf-8
module ProjectHelper

  def render_project_introduction(project)
    !!project.introduction ? content_tag(:div, raw(project.introduction), class: "description row") : nil
  end

  def render_project_video(project)
    !!project.video_url ? content_tag(:div, raw(project.video_url), class: "video row") : nil
  end

  def render_project_status(project)
    content_tag(:div, ("还差" + content_tag(:span, '38个分享', class: 'share-count')).html_safe, class: 'row') +
    content_tag(:div, "该项目就可进入公共筹集", class: 'row') +
    content_tag(:div, ("离结束还有" + content_tag(:span, '23天', class: 'day-count')).html_safe, class: 'row') +
    render_progress(project)
  end

  def render_project_weibo(project)
    if project.weibo_status
      render_weibo_status(project.weibo_status.status_id) +
      render_weibo_share(project)
    else
      nil
    end
  end

  def render_donate_box(project)
    content_tag :div, class: 'row' do
      link_to 'http://me.alipay.com/allenfantasy', target: '_blank' do
        tag(:img, src: "https://img.alipay.com/sys/personalprod/style/mc/btn-index.png")
      end
    end
  end

  def render_donate_form(project)
    render :partial => "donate_form", locals: { project: project }
  end

  def project_raise_type_options
    ProjectBasicInfo::RAISE_TYPE.collect {|k,v| [v[:description], v[:weight]] }
  end

  private
  def render_progress(project)
    progress, target = if (project.amount.nil? || project.amount == 0)
                         [0, 0]
                       else
                         [project.raised_amount, project.amount]
                       end
    content_tag :div, class: 'row' do
      render_progress_bar(progress, target) +
      tag(:br) +
      content_tag(:div, "当前进度：".html_safe + content_tag(:span,"#{progress} / #{target}"), class: "pull-right")
    end
  end

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

  def render_speed(percentage)
    flag = percentage >= 100 ? "success" : ""
    content_tag :span, nil, class: "speed #{flag}", style:"width: #{percentage}%"
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
end
