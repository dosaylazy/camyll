type t = {
  src_dir : string;
  dest_dir : string;
  grammar_dir : string;
  layout_dir : string;
  partial_dir : string;
  exclude : Re.re list;
  agda_dir : string;
  taxonomies : string list;
}

let src t = Filename.concat t.src_dir

let dest t = Filename.concat t.dest_dir

let grammar t = Filename.concat t.grammar_dir

let layout t = Filename.concat t.layout_dir

let partial t = Filename.concat t.partial_dir

let agda_dest t = Filename.concat t.dest_dir t.agda_dir

let (let+) opt f = match opt with
  | Some x -> Some (f x)
  | None -> None

let (and+) lhs rhs = match lhs, rhs with
  | Some lhs, Some rhs -> Some (lhs, rhs)
  | _, _ -> None

let of_toml toml =
  let open Toml.Lenses in
  let+ src_dir = get toml (key "source_dir" |-- string)
  and+ dest_dir = get toml (key "dest_dir" |-- string)
  and+ grammar_dir = get toml (key "grammar_dir" |-- string)
  and+ layout_dir = get toml (key "layout_dir" |-- string)
  and+ partial_dir = get toml (key "partial_dir" |-- string)
  and+ agda_dir = get toml (key "agda_dir" |-- string)
  and+ exclude = get toml (key "exclude" |-- array |-- strings)
  and+ taxonomies = get toml (key "taxonomies" |-- array |-- strings)
  in
  { src_dir
  ; dest_dir
  ; grammar_dir
  ; layout_dir
  ; partial_dir
  ; agda_dir
  ; exclude = List.map (fun g -> Re.compile (Re.Glob.glob g)) exclude
  ; taxonomies }