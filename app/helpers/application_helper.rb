module ApplicationHelper
  def full_title(page_title = "") # イコールだよ
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty? # if page_title.empty?で文字列が空かどうか
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end

