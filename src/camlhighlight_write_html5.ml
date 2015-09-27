(********************************************************************************)
(*	Camlhighlight_write_html5.ml
	Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open Camlhighlight_core

module List = BatList


(********************************************************************************)
(**	{1 Public functors}							*)
(********************************************************************************)

module Make (Html5: Html5_sigs.T with type 'a Xml.wrap = 'a and type 'a wrap = 'a and type 'a list_wrap = 'a list) =
struct
	open Html5

	let write ?(class_prefix = "hl_") ?(extra_classes = []) ?(dummy_lines = true) ?(linenums = false) source =
		let make_class ?(extra_classes = []) names = a_class (extra_classes @ (List.map (fun x -> class_prefix ^ x) names)) in
		let normal_line content = [pcdata "\n"; code ~a:[make_class ["line"]] content] in
		let dummy = if dummy_lines then [pcdata "\n"; code ~a:[make_class ["line"; "dummy"]] []] else [] in
		let class_of_special special =
			Sexplib.Sexp.to_string_mach (Camlhighlight_core.sexp_of_special_style special) in
		let elem_to_xhtml = function
			| (#normal_style, str)	     	   -> pcdata str
			| (#special_style as special, str) -> span ~a:[make_class [class_of_special special]] [pcdata str] in
		let convert_nums () =
			let source_len = List.length source in
			let width = String.length (string_of_int source_len) in
			let numline_to_xhtml num = normal_line [pcdata (Printf.sprintf "%0*d" width num)]
			in pre ~a:[make_class ["nums"]] (dummy @ (List.flatten (List.map numline_to_xhtml (List.init source_len (fun x -> x+1)))) @ dummy)
		and convert_source () =
			let source_line_to_xhtml line = normal_line (List.map elem_to_xhtml line)
			in pre ~a:[make_class ["code"]] (dummy @ (List.flatten (List.map source_line_to_xhtml source)) @ dummy)
		in div ~a:[make_class ~extra_classes ["main"]]
			(match linenums with
				| true	-> [convert_nums (); convert_source ()]
				| false -> [convert_source ()])
end

