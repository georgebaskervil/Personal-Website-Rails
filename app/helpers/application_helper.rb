module ApplicationHelper
  include BetterHtml::Helpers

  def unique_session_id
    session[:unique_session_id]
  end
end
