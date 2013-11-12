class DxFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(name, *args)
    @template.content_tag :fieldset, class: "field" do
      options = args.extract_options!
      content_tag :div, class: "fieldset-inner" do
        label(name, options[:label]) + super
      end
    end
  end
end
