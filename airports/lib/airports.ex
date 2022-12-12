defmodule Airports do
  @moduledoc """
  Documentation for `Airports`.
  """
alias NimbleCSV.RFC4180, as: CSV

  def airports_csv() do
    Application.app_dir(:airports, "/priv/airports.csv")
  end

  def airports_small() do
    Application.app_dir(:airports, "/priv/airports_small.csv")
  end

  def open_airports() do
    airports_csv()
    |> File.stream!()
    |> Flow.from_enumerable()
    |> Flow.map(fn row ->
      [row] = CSV.parse_string(row, skip_headers: false)
      %{
        id: Enum.at(row, 0),
        type: Enum.at(row, 2),
        name: Enum.at(row, 3),
        country: Enum.at(row, 8)
      }
    end)
    |> Flow.reject(&(&1.type == "closed"))
    |> Enum.to_list()
  end

  def open_airports_naive() do
    airports_csv()
    |> File.read!()
    |> CSV.parse_string()
    |> Enum.map(fn row ->
      %{
        id: Enum.at(row, 0),
        type: Enum.at(row, 2),
        name: Enum.at(row, 3),
        country: Enum.at(row, 8)
      }
    end)
    |> Enum.reject(&(&1.type == "closed"))
  end

  def open_airports_streams() do
    airports_csv()
    |> File.stream!()
    |> CSV.parse_stream()
    |> Stream.map(fn row ->
      %{
        id: :binary.copy(Enum.at(row, 0)),
        type: :binary.copy(Enum.at(row, 2)),
        name: :binary.copy(Enum.at(row, 3)),
        country: :binary.copy(Enum.at(row, 8))
      }
    end)
    |> Stream.reject(&(&1.type == "closed"))
    |> Enum.to_list()
  end

end
