# Plivo

## Prerequisites
- Elixir >= 1.5.2
- A plivo account

## Installation

1. Add `ex_plivo` to your list of dependencies in `mix.exs` and install it:

```elixir
def deps do
  [
    {:ex_plivo, "~> 0.1.0"}
  ]
end
```
```
$ mix deps.get
```

2. Create environment variables `AUTH_ID`, `AUTH_TOKEN`, `APP_ID` containing the appropriate values from your plivo account:

```
$ export AUTH_ID=YOUR_PLIVO_AUTH_ID
$ export AUTH_TOKEN=YOUR_PLIVO_AUTH_TOKEN
$ export APP_ID=YOUR_PLIVO_APP_ID
```

## Usage
You can call any functions from the `Adapter` module. For example:

```elixir
Plivo.Adapter.create_number("GB", "mobile", "voice")
```

## Docs
The docs can
be found at [https://hexdocs.pm/ex_plivo](https://hexdocs.pm/ex_plivo).

