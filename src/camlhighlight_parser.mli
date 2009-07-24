(********************************************************************************)
(*	Camlhighlight_parser.mli
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting source code into highlighted code.
*)

(********************************************************************************)
(**	{2 Exceptions}								*)
(********************************************************************************)

exception Failed_loading_style
exception Failed_loading_language
exception Failed_loading_language_regex


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val from_string: ?basedir: string -> Camlhighlight_core.lang_t -> string -> Camlhighlight_core.t

