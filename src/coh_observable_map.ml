open Coh_primitives

module Make_derived
  (Map: Coh_map.S) =
struct
module rec I :
sig
include Coh_map.S

module Filter : Coh_filter.S

val add_key_listener : t ->
  ?lite:bool -> Map_listener.Handle.t -> Key.View.t -> t

val remove_key_listener : t ->
  Map_listener.Handle.t -> t

val add_filter_listener : t ->
  ?lite:bool -> ?filter:Filter.View.t -> Map_listener.Handle.t -> t

val remove_filter_listener : t ->
  ?filter:Filter.View.t -> Map_listener.Handle.t -> t
end
=
struct
  module Filter = Coh_filter.I
  include Map
  let add_key_listener t ?lite handle key = failwith("nyi")
  let remove_key_listener t handle = failwith("nyi")
  let add_filter_listener t ?lite ?filter handle = failwith("nyi")
  let remove_filter_listener t ?filter handle = failwith("nyi")
end
and Map_event : sig
  include Coh_object.S
  val get_map : t -> I.Handle.t
  val get_id : t -> int32
  val get_key : t -> I.Key.View.t
  val get_old_value : t -> I.Value.View.t option
  val get_new_value : t -> I.Value.View.t option
  (* TODO toStream and dispatch *)
  val get_description : t -> string
end = struct
  include Coh_object.Opaque
  let get_map t = failwith("nyi")
  let get_id t = failwith("nyi")
  let get_key t = failwith("nyi")
  let get_old_value t = failwith("nyi")
  let get_new_value t = failwith("nyi")
  let get_description t = failwith("nyi")
end 
and Map_listener :
sig
    include Coh_object.S
    type entry_fun = Map_event.View.t -> unit
    val entry_inserted : t -> entry_fun
    val entry_updated : t -> entry_fun
    val entry_deleted : t -> entry_fun
end = struct
  type entry_fun = Map_event.View.t -> unit
  let no_op : entry_fun = fun _ -> ()
  module I = struct
   type t = {entry_inserted : entry_fun;entry_updated:entry_fun;entry_deleted:entry_fun}
  end
  open I
  include Coh_object.Make(I)
  let create ?(entry_inserted=no_op) ?(entry_updated=no_op) ?(entry_deleted=no_op) () =
    {entry_deleted;entry_inserted;entry_updated}
  let entry_inserted t = t.entry_inserted
  let entry_deleted t = t.entry_deleted
  let entry_updated t = t.entry_updated
end
include I
end

module Make(Key:Pofable.S) (Value:Pofable.S)
=
struct
  module Coh_map = struct include Coh_map.Make(Key)(Value) end
  include Make_derived(Coh_map)
end

module Make_from_object(Key:Pofable.S) (Value:Pofable.S)(Obj:Coh_object.S)
= struct
  module Coh_map = struct include Coh_map.Make_derived(Key)(Value)(Obj) end
  include Make_derived(Coh_map)
end

