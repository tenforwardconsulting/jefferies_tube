module JefferiesTube::ApplicationHelper
  def naive_page_title
    return @page_title if @page_title
    controller = params[:controller]

    title = case params[:action]
    when "new"
      "New #{controller.singularize.titlecase}"
    when "edit"
      "Editing #{controller.singularize.titlecase}"
    when "index"
      "Manage #{controller.titlecase}"
    else
      controller.titlecase
    end

    title
  end
end
