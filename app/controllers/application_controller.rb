require "nokogiri"
require "kramdown"
require "yaml"
require "digest"
require "date" # Added to handle Date parsing

class ApplicationController < ActionController::Base
  before_action :set_custom_headers
  before_action :increment_HTTP_req_counter
  before_action :load_images
  before_action :load_articles
  before_action :set_all_posts
  before_action :set_latest_posts
  before_action :set_article, only: [ :show ]

  def show
    return unless @article.nil?

    Rails.logger.warn "Article not found with identifier: #{params[:id]}"
    render plain: "Article not found", status: :not_found
  end

  private

  def set_custom_headers
    response.set_header("Cross-Origin-Embedder-Policy", "require-corp")
    response.set_header("Cross-Origin-Opener-Policy", "same-origin")
    response.set_header("X-UA-Compatible", "IE=edge,chrome=1")
  end

  def increment_HTTP_req_counter
    counter = HttpReqCounter.first_or_create
    counter.increment(:count)
    counter.save!
  end

  def load_images
    Rails.logger.debug "Fetching images_list from cache or computing it"

    # Generate a unique cache key based on image files' modification times
    images_cache_key = "images_list-#{images_checksum}"

    @images = Rails.cache.fetch(images_cache_key) do
      glob_pattern = Rails.root.join("app/photos/JPGs/**/*.JPG")
      Rails.logger.debug { "Glob pattern: #{glob_pattern}" }

      photos_dir = Rails.root.join("app/photos/JPGs")
      unless Dir.exist?(photos_dir)
        Rails.logger.warn "Directory app/photos/JPGs does not exist."
        return []
      end

      files = Dir.glob(glob_pattern)
      Rails.logger.debug { "Files found: #{files.size}" }
      Rails.logger.debug { "Files: #{files.join(', ')}" }

      mapped_files = files.map { |f| f.sub(%r{.*app/photos/}, "") }
      Rails.logger.debug { "Mapped files count: #{mapped_files.size}" }
      Rails.logger.debug { "Mapped files: #{mapped_files.join(', ')}" }

      mapped_files
    end

    Rails.logger.debug { "Total images to display: #{@images.size}" }
  end

  def load_articles
    Rails.logger.debug "Fetching articles_list from cache or computing it"

    # Generate a unique cache key based on article files' modification times
    articles_cache_key = "articles_list-#{articles_checksum}"

    @articles = Rails.cache.fetch(articles_cache_key) do
      articles_glob = Rails.root.join("app//articles/**/*.md")
      Rails.logger.debug { "Articles glob pattern: #{articles_glob}" }

      articles_dir = Rails.root.join("app//articles")
      unless Dir.exist?(articles_dir)
        Rails.logger.warn "Directory app//articles does not exist."
        return []
      end

      article_files = Dir.glob(articles_glob)
      Rails.logger.debug { "Article files found: #{article_files.size}" }
      Rails.logger.debug { "Article files: #{article_files.join(', ')}" }

      articles = article_files.map do |file|
        content = File.read(file)
        parts = content.split(/^---$/, 3)

        if parts.size >= 3
          front_matter = parts[1]
          body = parts[2]

          begin
            metadata = YAML.safe_load(front_matter, permitted_classes: [ Date ]) # Updated safe_load with permitted_classes

            # Extract filename as slug if not specified
            slug = metadata["slug"] || File.basename(file, ".md")

            # Process tags from comma-separated string or array
            tags = if metadata["tags"].is_a?(String)
                    metadata["tags"].split(",").map(&:strip)
            elsif metadata["tags"].is_a?(Array)
                    metadata["tags"]
            else
                    []
            end

            # Get the section or default to 'Blog'
            section = metadata["section"] || "Blog"

            # Handle the updated_at date
            updated_at = metadata["updatedAt"] || metadata["publishedAt"]

            # Handle the preview image
            preview_image = metadata["previewImage"]

            {
              title: metadata["title"],
              description: metadata["description"],
              published_at: metadata["publishedAt"], # Directly use the Date object
              updated_at: updated_at,
              content_html: Nokogiri::HTML::DocumentFragment.parse(Kramdown::Document.new(body).to_html).tap do |doc|
                doc.traverse do |node|
                  if node.element?
                    existing_classes = node["class"] || ""
                    node["class"] = (existing_classes.split + [ "posts-text" ]).uniq.join(" ")
                  end
                end
              end.to_html,
              file_path: file,
              slug: slug,
              tags: tags,
              section: section,
              author: metadata["author"] || "George Baskerville",
              preview_image: preview_image
            }
          rescue StandardError => e
            Rails.logger.warn "Error parsing YAML front matter in #{file}: #{e.message}"
            nil
          end
        else
          Rails.logger.warn "No valid front matter found in #{file}"
          nil
        end
      end.compact

      # Sort articles by published_at date in descending order
      articles.sort_by { |article| article[:published_at] }.reverse
    end

    Rails.logger.debug { "Total articles to display: #{@articles.size}" }
  end

  def set_article
    identifier = params[:id]
    @article = @articles.find do |article|
      article[:slug] == identifier || File.basename(article[:file_path], ".md") == identifier
    end
  end

  def set_latest_posts
    @latest_posts = @articles&.first(4) || []
  end

  def set_all_posts
    @all_posts = @articles || []
  end

  # Generates a checksum based on the filenames and their last modified times
  def images_checksum
    files = Rails.root.glob("app/photos/JPGs/**/*.JPG")
    Digest::MD5.hexdigest(
      files.sort.map { |f| "#{f}:#{File.mtime(f).to_i}" }.join("|")
    )
  end

  def articles_checksum
    files = Rails.root.glob("app/articles/**/*.md")
    Digest::MD5.hexdigest(
      files.sort.map { |f| "#{f}:#{File.mtime(f).to_i}" }.join("|")
    )
  end

  def meta_image
    # Use a fixed default image since preview images will be generated programmatically in the future
    vite_asset_path("~/images/site-screenshot.png")
  end
end
