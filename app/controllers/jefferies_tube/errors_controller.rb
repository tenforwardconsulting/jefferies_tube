class JefferiesTube::ErrorsController < ApplicationController
  def render_404
    render_error_page 404
  end

  def render_500
    render_error_page 500
  end

  private
  def render_error_page(code)
    begin
      render template: "/errors/#{code}", layout: true, status: code
    rescue ActionView::MissingTemplate
      render "render_#{code}".to_sym, layout: true, status: code
    end
  end
end