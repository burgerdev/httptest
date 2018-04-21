open Cohttp_lwt
open Cohttp_lwt_unix

type handler = Server.conn -> Request.t -> Body.t -> (Response.t * Body.t) Lwt.t

let not_found _conn _req _body =
  Server.respond_not_found ()

let mux: (Request.t -> handler option) -> handler = fun get_handler_opt conn req body ->
  match get_handler_opt req with
  | Some handler -> handler conn req body
  | None -> not_found conn req body

let mux_path: (string -> handler option) -> handler = fun get_handler_opt ->
  mux (fun req -> Request.uri req |> Uri.path |> get_handler_opt)
