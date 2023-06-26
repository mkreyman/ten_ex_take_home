alias TenExTakeHome.Marvel.API.{
  Base,
  Characters
}

alias TenExTakeHome.Repo
alias TenExTakeHomeWeb.Router.Helpers, as: Routes

import_if_available(Ecto.Query, only: [from: 2])
import_if_available(Ecto.Changeset)
