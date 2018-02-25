defmodule Plivo.Adapter do
  @moduledoc """
  An interface used to make api calls to plivo
  """

  @doc """
  Creates an endpoint for a new user in plivo.
  
  Parameters:
    - username
    - password
    - alias
  Returns:
    - A map containing:
      - username
      - alias
      - message
      - endpoint_id
      - api_id
  """
  def create_endpoint(username, password, alias) do
    # Body of the HTTP request
    body =
      %{username: username,
        password: password,
        alias: alias,
        app_id: app_id()}

    # `with` statements allow for easier chaining of requests with structured responses without nested case-do's
    # if any request fails, `with` will return the error {:error, err} before running the next request
    with {:ok, %HTTPoison.Response{body: response_body}} <-
           Plivo.post("/Endpoint/", body, basic_auth_header()), # Send POST request to Plivo api (creates a new endpoint)
         do: {:ok, response_body} # Return {:ok, response_body}
  end

  @doc """
  Deletes an endpoint for a user in plivo (when user gets deleted for example)

  Parameters:
    - endpoint id
  """
  def delete_endpoint(endpoint_id) do
    with {:ok, _response} <-
           Plivo.delete("/Endpoint/#{endpoint_id}", basic_auth_header()),
         do: :ok
  end

  @doc """
  Get all the details for a certain call (by UUID)

  Parameters:
    - UUID
  Returns:
    - Map with:
      - answer_time
      - api_id
      - bill_duration
      - billed_duration
      - call_direction
      - call_duration
      - call_uuid
      - end_time
      - from_number
      - initiation_time
      - parent_call_uuid
      - resource_uri,
      - to_number
      - total_amount
      - total_rate
  """
  def get_call_details(uuid) do
    with {:ok, %HTTPoison.Response{body: response_body}} <-
           Plivo.get("/Call/#{uuid}/", basic_auth_header()),
         do: {:ok, response_body}
  end

  @doc """
  Start a recording of a call (can be invoked at any time within a call)

  Parameters:
    - UUID
    - Time limit (defaults at 60)
  Returns:
    - Map with:
      - url
      - message
      - recording_id
      - api_id
  """
  def start_recording(uuid, time_limit \\ 60) do
    with {:ok, %HTTPoison.Response{body: response_body}} <-
           Plivo.post("/Call/#{uuid}/Record/",
                      %{time_limit: time_limit},
                      basic_auth_header()),
         do: {:ok, response_body}
  end

  @doc """
  Stop a recording of a call (can be invoked at any time within a call)

  Parameters:
    - UUID
    - Recording URL
  """
  def stop_recording(uuid, url) do
    with {:ok, _response} <-
           Plivo.delete("/Call/#{uuid}/Record/", basic_auth_header(), params: [url: url]),
    do: :ok
  end

  @doc """
  Creates a new number

  Parameters:
    - Country iso (e.g. "GB")
  Returns
    - New phone number
  """
  def create_number(country_iso) do
    with {:ok, %HTTPoison.Response{body: search_response_body}} <-
           Plivo.get("/PhoneNumber/",
                     basic_auth_header(),
                     params: [type: "mobile",
                              services: "voice",
                              country_iso: country_iso]),
         new_number =
          search_response_body
            |> Map.get("objects")
            |> List.first()
            |> Map.get("number"),
         {:ok, %HTTPoison.Response{body: %{"message" => "created"}}} <-
           Plivo.post("/PhoneNumber/#{new_number}/", %{app_id: app_id()}, basic_auth_header()),
         do: {:ok, new_number}
  end

  # Generates an html request header with basic authentication for the plivo api
  defp basic_auth_header do
    auth_id = Application.get_env(:plivo, :auth_id)
    auth_token = Application.get_env(:plivo, :auth_token)
    basic_auth = "Basic " <> Base.encode64("#{auth_id}:#{auth_token}") # Concatenation

    [{"authorization", basic_auth}, {"Content-Type", "application/json"}]
  end

  defp app_id, do: Application.get_env(:plivo, :app_id)
end
