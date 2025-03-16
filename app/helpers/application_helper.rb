module ApplicationHelper
  include BetterHtml::Helpers

  def page_title(page_specific_title = nil)
    base_title = "George Baskerville's Personal Website"
    route_title = if page_specific_title.present?
      page_specific_title
    elsif request.path == "/"
      nil
    else
      request.path.split("/").reject(&:empty?).map(&:titleize).join(" - ")
    end
    
    route_title.present? ? "#{base_title} - #{route_title}" : base_title
  end
end
