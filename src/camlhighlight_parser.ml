(********************************************************************************)
(*	Camlhighlight_parser.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtList
open ExtString
open Camlhighlight_core
open Camlhighlight_lowlevel


(********************************************************************************)
(**	{2 Exceptions}								*)
(********************************************************************************)

exception Failed_loading_style
exception Failed_loading_language
exception Failed_loading_language_regex


(********************************************************************************)
(**	{2 Private values and functions}					*)
(********************************************************************************)

let regexp alpha = ['a' - 'z']
let regexp begin_special = "<span class=\"hl " alpha+ "\">"
let regexp end_special = "</span>"
let regexp regular = [^ '<' ]+


let rec translator accum context = lexer
	| begin_special ->
		let last = (Ulexing.lexeme_length lexbuf) - 18 in
		let spec = Ulexing.utf8_sub_lexeme lexbuf 16 last
		in translator accum (`Special_context spec) lexbuf
	| end_special ->
		translator accum `Top_context lexbuf
	| regular ->
		let lexeme = Ulexing.utf8_lexeme lexbuf in
		let addition = match context with
			| `Top_context		-> Default (lexeme)
			| `Special_context s	-> Special (s, lexeme)
		in translator (addition::accum) context lexbuf
	| eof ->
		accum


let translate_html =
	let rex = Pcre.regexp "&(\\w+|(#\\d+));" in
	fun str ->
		let subst = function
			| "&lt;"	-> "<"
			| "&gt;"	-> ">"
			| "&amp;"	-> "&"
			| "&quot;"	-> "\""
			| "&#64;"	-> "@"
			| x		-> x in
		let convert_entities = function
			| Default x	 -> Default (Pcre.substitute ~rex ~subst x)
			| Special (s, x) -> Special (s, Pcre.substitute ~rex ~subst x) in
		let translate_line line =
			let lexbuf = Ulexing.from_utf8_string line in
			let rev_trans = translator [] `Top_context lexbuf
			in List.rev_map convert_entities rev_trans in
		let lines = String.nsplit str "\n"
		in List.map translate_line lines


let gen =
	let gen = Camlhighlight_lowlevel.create (Html) in
	let () = Camlhighlight_lowlevel.set_fragment_code gen true in
	let () = Camlhighlight_lowlevel.set_preformatting gen Wrap_disabled 0 8
	in gen


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)


(**	An invocation of [from_string lang source] will create a value of type
	{!Camlhighlight.t} containing the syntax-highlighted version of the
	source-code in [string] format passed in the [source] parameter.  The
	[lang] parameter tells the highlighter which conventions are used for
	highlighting;  it is a value of type {!Camlhighlight.lang_t}.  Note
	that you can specify [txt] as the language if you do not wish for
	highlighting to be done.
*)
let from_string ?(basedir = "/home/dario/.local/share/highlight") lang source =
	let () = match Camlhighlight_lowlevel.get_style_name gen with
		| "" ->
			let style = basedir ^ "/themes/kwrite.style"
			in if not (Camlhighlight_lowlevel.init_theme gen style)
			then raise Failed_loading_style
		| _ ->
			() in
	let lang_def = basedir ^ "/langDefs/" ^ lang ^ ".lang" in
	let () = match Camlhighlight_lowlevel.load_language gen lang_def with
		| Load_failed		-> raise Failed_loading_language
		| Load_failed_regex	-> raise Failed_loading_language_regex
		| _			-> () in
	let html = Camlhighlight_lowlevel.generate_string gen source
	in (lang, translate_html html)

