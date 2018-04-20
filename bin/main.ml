open Lwt
open Cohttp_lwt_unix

open Testserver

let bin_name = "test-server"
let bin_version = "0.1"

let mux = function
  | "/echo" -> Some Testserver.echo
  | "/example" -> Some Testserver.cohttp_example_server
  | _ -> None

let server src port =
  Conduit_lwt_unix.init ~src () >>= fun ctx ->
  let ctx = Cohttp_lwt_unix.Client.custom_ctx ~ctx () in
  let callback = Testserver.mux_path mux in
  let handler = Server.make ~callback () in
  Server.create ~ctx ~mode:(`TCP (`Port port)) handler

let main host port _ =
  Lwt_main.run @@ server host port

(* Logging stuff, copy pasta from docs *)

let setup_log style_renderer level =
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level level;
  Logs.set_reporter (Logs_fmt.reporter ());
  ()

(* Command line interface *)

open Cmdliner

let log_term =
  Term.(const setup_log $ Fmt_cli.style_renderer () $ Logs_cli.level ())

(* Cmdliner stuff *)

let host_term =
  let doc = "Bind address to listen on." in
  Arg.(value & opt string "127.0.0.1" & info ["b"; "bind"] ~docv:"BIND-ADDRESS" ~doc)

let port_term =
  let doc = "TCP port to listen on." in
  Arg.(value & opt int 8080 & info ["p"; "port"] ~docv:"PORT" ~doc)

let main_term = Term.(const main
                      $ host_term
                      $ port_term
                      $ log_term
                     )

let info =
  let doc = "HTTP test server" in
  Term.info bin_name ~version:bin_version ~doc

let () = match Term.eval (main_term, info) with `Error _ -> exit 1 | _ -> exit 0
