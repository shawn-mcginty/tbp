let main ()=
  let port = match Array.length Sys.argv with
    | 0 -> 9000
    | 1 -> 9000
    | _ -> int_of_string (Array.get Sys.argv 1)
  in
  let conf = Naboris.ServerConfig.create ()
    |> Naboris.ServerConfig.setOnListen(fun () ->
      let () = print_endline ("Naboris now listening on port " ^ (string_of_int port)) in
      print_endline ("Visit http://localhost:" ^ (string_of_int port)))
    |> Naboris.ServerConfig.setRequestHandler(fun route req res ->
      match (Naboris.Route.meth route, Naboris.Route.path route) with
        | (GET, ["plaintext"]) ->
          res
          |> Naboris.Res.addHeader ("Server", "naboris")
          |> Naboris.Res.text req "Hello, World!"
        | _ ->
          Naboris.Res.status 404 res
            |> Naboris.Res.text req "Not found") in
  Naboris.listenAndWaitForever port conf

let _ = Lwt_engine.set (new Lwt_engine.libev ())
let _ = Lwt_main.run(main ())
