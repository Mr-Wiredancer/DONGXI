class DxFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, to: :@template
  #def text_field(name, *args)
    #@template.content_tag :fieldset, class: "field" do
      #options = args.extract_options!
      #content_tag :div, class: "fieldset-inner" do
        #label(name, options[:label]) + super
      #end
    #end
  #end

  # REFACTOR: all classes will go to 'dx-form'

  def label(name, *args)
    content_tag :div, class: 'dx-form-label' do
      super
    end
  end
  def hint(*args)
    options = args.extract_options!
    content_tag :div, class: 'dx-form-hint' do
      Array(options[:text]).map do |t|
        content_tag(:p, t)
      end.join("").html_safe
    end
  end
  def text_area(name, *args)
    content_tag :div, class: 'dx-form-textarea' do
      super
    end
  end
  def cktext_area(name, *args)
    content_tag :div, class: 'dx-form-ck-textarea' do
      super
    end
  end
  def text_field(name, *args)
    options = args.extract_options!
    return super(name, options) if options[:original] == true
    content_tag :div, class: 'dx-form-textfield' do
      super
    end
  end
end
