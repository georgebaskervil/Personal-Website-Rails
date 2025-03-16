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

  def site_name
    "George Baskerville's Personal Website"
  end

  def page_specific_title
    if @article.present? && @article[:title].present?
      @article[:title]
    elsif request.path == "/"
      nil
    else
      request.path.split("/").reject(&:empty?).map(&:titleize).join(" - ")
    end
  end

  def meta_description
    if @article.present? && @article[:description].present?
      @article[:description]
    else
      "I'm George, a mad (computer) scientist. Here's my website."
    end
  end

  def meta_keywords
    base_keywords = %w[George Baskerville geor.me personal website programming]
    if @article.present?
      # Add article-specific keywords
      article_keywords = @article[:tags] || []
      base_keywords + article_keywords
    else
      current_section = request.path.split("/").reject(&:empty?).first
      base_keywords + [ current_section ].compact
    end.join(", ")
  end

  def meta_image
    if @article.present? && @article[:preview_image].present?
      vite_asset_path(@article[:preview_image])
    else
      vite_asset_path("~/images/site-screenshot.png")
    end
  end

  def page_name
    if @article.present?
      "George Baskerville - #{@article[:title]}"
    else
      current_page_title = yield(:page_title).presence
      "George Baskerville#{" - #{current_page_title}" if current_page_title}"
    end
  end

  def article_published_date
    @article&.dig(:published_at)&.iso8601 if @article.present?
  end

  def article_modified_date
    @article&.dig(:updated_at)&.iso8601 if @article.present?
  end

  def article_author
    @article&.dig(:author) || "George Baskerville"
  end

  def page_type
    if @article.present?
      "article"
    else
      "website"
    end
  end

  def canonical_url
    base_url = "https://geor.me"
    if @article.present? && @article[:slug].present?
      "#{base_url}/posts/#{@article[:slug]}"
    else
      "#{base_url}#{request.path}"
    end
  end

  def article_section
    if @article.present? && @article[:section].present?
      @article[:section]
    elsif request.path.start_with?("/posts")
      "Blog"
    else
      request.path.split("/").reject(&:empty?).first&.titleize
    end
  end

  def article_tags
    return [] if @article.blank?

    @article[:tags] || []
  end

  def article_metadata
    return {} if @article.blank?

    {
      author: article_author,
      published_date: article_published_date,
      modified_date: article_modified_date,
      section: article_section,
      tags: article_tags,
      canonical_url: canonical_url,
      type: "article"
    }
  end
end
