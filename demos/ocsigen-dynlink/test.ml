(********************************************************************************)
(*	main.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Ocsigen demo of Camlhighlight library.
*)

open XHTML.M


let test_service =
	Eliom_services.new_service 
		~path: [""]
		~get_params: Eliom_parameters.unit
		()


let test_handler sp () () =
	let ch = open_in "test.ml" in
	let str = Std.input_all ch in
	let () = close_in ch in
	let hilite = Camlhighlight_parser.from_string "ml" str in
	let hilite_xhtml = Camlhighlight_write_xhtml.write ~linenums:true ~zebra:true hilite in
	let css_uri = Eliom_predefmod.Xhtml.make_uri (Eliom_services.static_dir sp) sp ["css"; "highlight.css"]
	in Lwt.return
		(html
			(head (title (pcdata "Test")) [Eliom_predefmod.Xhtml.css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
			(body [hilite_xhtml]))


let () = Eliom_predefmod.Xhtml.register test_service test_handler


(********************************************************************************)

(**	The following code does nothing; it is used to illustrate the syntax
	highlighting on different language elements.
*)

let ola1 = 10

let ola2 = 20.123

let ola3 = "This is a string with \n escaped characters"

type rec_t =
	{
	bye1: string;
	bye2: float;
	}

type foo_t =
	| One
	| Two
	| Three

type bar_t =
	[ `One
	| `Two
	| `Three
	]
