class VideosController < ApplicationController
  def gta_optimised
    render template: "videos/gta_optimised_video.m3u8.erb", content_type: "application/x-mpegURL"
  end

  def mc_optimised
    render template: "videos/mc_optimised_video.m3u8.erb", content_type: "application/x-mpegURL"
  end

  def soapcarving_optimised
    render template: "videos/soapcarving_optimised_video.m3u8.erb", content_type: "application/x-mpegURL"
  end

  def subwaysurfers_optimised
    render template: "videos/subwaysurfers_optimised_video.m3u8.erb", content_type: "application/x-mpegURL"
  end
end
