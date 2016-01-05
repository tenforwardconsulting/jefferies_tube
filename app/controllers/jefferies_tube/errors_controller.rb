class JefferiesTube::ErrorsController < ApplicationController
  def render_404
    render_error_page 404
  end

  def render_500
    render_error_page 500
  end

  private
  def render_error_page(code)
    # boolean based on if there is a default layout for the current mime type
    layout = !!self.send(:_layout)
    begin
      render template: "/errors/#{code}", layout: layout, status: code
    rescue ActionView::MissingTemplate
      render "render_#{code}".to_sym, layout: layout, status: code
    end
  end
end