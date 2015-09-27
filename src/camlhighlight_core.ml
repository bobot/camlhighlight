(********************************************************************************)
(*	Camlhighlight_core.ml
	Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Definition of Camlhighlight core types.
*)

open Sexplib.Std


(********************************************************************************)
(**	{1 Type definitions}							*)
(********************************************************************************)

(**	How the source language is specified.
*)
type lang = string with sexp


type normal_style =
	[ `Norm
	] with sexp


type special_style =
	(* General common styles *)
	[ `Kwd			(** keyword *)
	| `Type			(** type *)
	| `Utyp			(** usertype *)
	| `Str			(** string *)
	| `Rex			(** regexp *)
	| `Sch			(** specialchar *)
	| `Com			(** comment *)
	| `Num			(** number *)
	| `Prep			(** preproc *)
	| `Sym			(** symbol *)
	| `Fun			(** function *)
	| `Cbrk			(** cbracket *)

	(* Predefined variables and functions (for instance glsl) *)
	| `Pvar			(** predef_var *)
	| `Pfun			(** predef_func *)

	(* OOP *)
	| `Clas			(** classname *)

	(* Line numbers *)
	| `Line			(** linenum *)

	(* Internet related *)
	| `Url			(** url *)

	(* Elements for Changelog and Log files *)
	| `Date			(** date *)
	| `Time			(** time *)
	| `File			(** file *)
	| `Ip			(** ip *)
	| `Name			(** name *)

	(* Prolog, Perl... *)
	| `Var			(** variable *)

	(* Latex *)
	| `Ital			(** italics *)
	| `Bold			(** bold *)
	| `Undr			(** underline *)
	| `Fixd			(** fixed *)
	| `Arg			(** argument *)
	| `Oarg			(** optionalargument *)
	| `Math			(** math *)
	| `Bibx			(** bibtex *)

	(* Diff files *)
	| `Old			(** oldfile *)
	| `New			(** newfile *)
	| `Diff			(** difflines *)

	(* CSS *)
	| `Sel			(** selector *)
	| `Prop			(** property *)
	| `Val			(** value *)

	(* Oz *)
	| `Atom			(** atom *)
	| `Meta			(** meta *)
	] with sexp


(**	Styles.
*)
type style = [ normal_style | special_style ] with sexp


(**	An element is a pair consisting of a style and the contents.
*)
type elem = style * string with sexp


(**	A line is composed of a list of individual elements.
*)
type line = elem list with sexp


(**	The value of highlighted source-code samples.  It's just a list of lines.
*)
type t = line list with sexp

