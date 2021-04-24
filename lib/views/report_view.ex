defmodule Api.Views.ReportView do
    use JSONAPI.View
  
    def fields, do: [:id, :description, :reservation]
    def type, do: "report"
    def relationships, do: []
  end