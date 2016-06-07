open Coh_primitives

module Derived =
struct
module Make(Key:Coh_object.S)(Value:Coh_object.S)(Parent:Coh_object.S) =
  (*(Map: Coh_map.S) : Coh_map.S with type t = Map.t and module Key = Map.Key and module Value = Map.Value = *) 
struct
module rec I :
sig
include Coh_map.S with module Key = Key and module Value = Value and type t = Parent.t

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
  include Coh_map.Derived.Make(Key)(Value)(Parent)
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
module type S = module type of I
end
end
module Object =
struct
module Make(Key:Coh_object.S) (Value:Coh_object.S) =
struct
  module Coh_map = struct include Coh_map.Make(Key)(Value) end
  include Derived.Make(Key)(Value)(Coh_map)
end

module Derived = struct
module Make(Key:Coh_object.S) (Value:Coh_object.S)(Obj:Coh_object.S)
= struct
  include Derived.Make(Key)(Value)(Obj)
end
end
end
module Opaque = Object.Make(Coh_object.Opaque)(Coh_object.Opaque)

module Pof =
struct
module Make(Key:Pofable.S) (Value:Pofable.S)  (* : S with module Key = Key and module Value = Value *) =
struct
  module Coh_map = struct include Coh_map.Make(Key)(Value) end
  module D = Derived.Make(Key)(Value)(Coh_map)
  include (D : module type of D with module Key := Key)
  module Key = Key
end

module Derived = struct
module Make(Key:Pofable.S)(Value:Pofable.S)(Obj:Coh_object.S)
= struct
  module Coh_map = struct include Coh_map.Derived.Make(Key)(Value)(Obj) end
  include Derived.Make(Key)(Value)(Coh_map)
end
end
end
