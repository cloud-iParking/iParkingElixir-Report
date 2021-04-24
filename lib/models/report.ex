defmodule Api.Models.Report do
    @db_name Application.get_env(:api_test, :db_db)
    @db_table "reports"

use Api.Models.ReportRepository

defstruct [
    :id,
    :description,
    :reservation
  ]
end
