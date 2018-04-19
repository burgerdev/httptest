open Cohttp_lwt_unix

let not_found _conn _req _body =
  Server.respond_not_found ()

let mux get_handler_opt conn req body =
match get_handler_opt req with
| Some handler -> handler conn req body
| None -> not_found conn req body

let mux_path get_handler_opt =
  mux (fun req -> Request.uri req |> Uri.path |> get_handler_opt)
