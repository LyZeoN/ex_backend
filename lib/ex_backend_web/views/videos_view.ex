defmodule ExBackendWeb.VideosView do
  use ExBackendWeb, :view
  alias ExBackendWeb.VideosView

  def render("index.json", %{videos: videos}) do
    %{
      size: videos.size,
      offset: videos.offset,
      total: videos.total,
      data: render_many(videos.videos, VideosView, "video.json")
    }
  end

  def render("show.json", %{video: video}) do
    %{data: render_one(video, VideosView, "video.json")}
  end

  def render("video.json", %{videos: video}) do
    %{
      id: video["id"],
      title: video["title"],
      additional_title: video["additional_title"],
      available: video["platforms"]["ftv"]["status"] == "available",
      licensing: video["licensing"],
      legacy_id: video["legacy_id"],
      channel: video["channel"]["id"],
      region: video["channel"]["region"],
      creation: video["created_at"],
      broadcasted_at: video["broadcasted_at"],
      workflows_count: video["workflows_count"],
      audio_tracks: video["audio_tracks"],
      text_tracks: video["text_tracks"],
      manifest_url: video["manifest_url"],
      parent_id: video["parent_id"],
      broadcasted_live: video["broadcasted_live"],
      duration: video["duration"],
      type: video["type"]["id"],
    }
  end
end