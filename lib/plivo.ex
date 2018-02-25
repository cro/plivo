defmodule Plivo do
  @moduledoc """
  Documentation for Plivo.
  """
  use HTTPoison.Base

  @endpoint "https://api.plivo.com/v1/Account/#{Application.get_env(:plivo, :auth_id)}"

  def process_request_body(string_body) do
    Poison.encode!(string_body)
  end

  def process_response_body(string_body) do
    Poison.decode!(string_body)
  end

  def process_url(url) do
    @endpoint <> url
  end
end
