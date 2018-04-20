open Lwt
open Cohttp
open Cohttp_lwt_unix

let not_found _conn req body =
  Server.respond_not_found ()

let cohttp_example_server _conn req body =
  let uri = req |> Request.uri |> Uri.to_string in
  let meth = req |> Request.meth |> Code.string_of_method in
  let headers = req |> Request.headers |> Header.to_string in
  body |> Cohttp_lwt.Body.to_string >|= (fun body ->
      (Printf.sprintf "Uri: %s\nMethod: %s\nHeaders\nHeaders: %s\nBody: %s"
         uri meth headers body))
  >>= (fun body -> Server.respond_string ~status:`OK ~body ())

let echo _conn req body =
  let version = Request.version req |> Cohttp.Code.string_of_version in
  let path = req |> Request.uri |> Uri.path_and_query in
  let meth = req |> Request.meth |> Code.string_of_method in
  let headers = req |> Request.headers |> Header.to_string in
  body |> Cohttp_lwt.Body.to_string >|= (fun body ->
      (Printf.sprintf "%s %s %s\n%s\n%s"
         meth path version headers body))
  >>= (fun body -> Server.respond_string ~status:`OK ~body ())
