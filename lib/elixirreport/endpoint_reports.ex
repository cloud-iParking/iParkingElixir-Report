defmodule Api.EndpointReports do
    use Plug.Router
  
    alias Api.Views.ReportView
    alias Api.Models.Report
    alias Api.Plugs.JsonTestPlug
  
    @api_port Application.get_env(:api_test, :api_port)
    @api_host Application.get_env(:api_test, :api_host)
    @api_scheme Application.get_env(:api_test, :api_scheme)
  
    plug :match
    plug :dispatch
    plug JsonTestPlug
    plug :encode_response
    plug Corsica, origins: "http://localhost:4200"

    defp encode_response(conn, _) do
        conn
        |>send_resp(conn.status, conn.assigns |> Map.get(:jsonapi, %{}) |> Poison.encode!)
    end

    get "/", private: %{view: ReportView}  do
        params = Map.get(conn.params, "filter", %{})
    
        {_, reports} =  Report.find(params)
    
        conn
        |> put_status(200)
        |> assign(:jsonapi, reports)
    end

    get "/:id", private: %{view: ReportView}  do
        {parsedId, ""} = Integer.parse(id)
    
        case Report.get(parsedId) do
          {:ok, report} ->
            conn
            |> put_status(200)
            |> assign(:jsonapi, report)
    
          :error ->
            conn
            |> put_status(404)
            |> assign(:jsonapi, %{"error" => "'report' not found"})
        end
      end

    post "/add", private: %{view: ReportView} do
        {id, description, reservation} = {
            Map.get(conn.params, "id", nil),
            Map.get(conn.params, "description", nil),
            Map.get(conn.params, "reservation", nil)
        }
        cond do
            is_nil(description)->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "No description!"})
            
            
            is_nil(reservation)->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "No reservation!"})
            
            true ->
            case %Report{ id: id,
                          description: description,
                          reservation: reservation } |> Report.saveReport do
                {:ok, createdEntry} ->
                    uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"

                    conn
                    |> put_resp_header("location", "#{uri}#{id}")
                    |> put_status(201)
                    |> assign(:jsonapi, createdEntry)
                :error ->
                    conn
                        |> put_status(500)
                        |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
            end
        end
    end
end