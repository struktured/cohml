open Coh_primitives
open Ctypes
open Foreign
module Derived =
struct
module Make(Key:Coh_object.S)(Value:Coh_object.S)(T:Coh_object.T) =
  (*(Map: Coh_map.S) : Coh_map.S with type t = Map.t and module Key = Map.Key and module Value = Map.Value = *) 
struct
module rec I :
sig
include Coh_map.S with module Key = Key and module Value = Value and module Self.T = T

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
  include Coh_map.Derived.Make(Key)(Value)(T)
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
  module T = struct
   let name = "map_listener"
   type t 
  end
  open T
  include Coh_object.Make(T)
  module Foreign = struct
    let create = Self.foreign "create" @@
      Map_event.View.t @-> void @->
      Map_event.View.t @-> void @->
      Map_event.View.t @-> void @->
      returning t
  end

  let create ?(entry_inserted=no_op) ?(entry_updated=no_op) ?(entry_deleted=no_op) () =
    let entry_inserted' v =
      entry_inserted v; void in
    let entry_updated' v =
      entry_updated v; void in
    let entry_deleted' v =
      entry_deleted v; void in
    Foreign.create entry_inserted entry_updated' entry_deleted'
  let entry_inserted = failwith("nyi")
    (* (t @-> returning (Map_event.View.t @-> returning void))- *)
end
include I
module type S = module type of I
end
end


module Object =
struct
module Make(Key:Coh_object.S) (Value:Coh_object.S) =
struct
  module Parent = struct include Coh_map.Make(Key)(Value) end
  include Derived.Make(Key)(Value)(Coh_map)
end

module Derived = struct
module Make(Key:Coh_object.S) (Value:Coh_object.S)(Parent:Coh_object.T)
= struct
  include Derived.Make(Key)(Value)(Parent)
end
end
end
module Opaque = Object.Make(Coh_object.Opaque)(Coh_object.Opaque)

module type S = Opaque.S
module Pof =
struct
module type S =
sig
  module Key : Pofable.S
  module Value : Pofable.S
end

module Make(Key:Pofable.S) (Value:Pofable.S)  : S with module Key = Key and module Value = Value  =
struct
  module Parent = struct include Coh_map.Make(Key)(Value) end
  module D = Derived.Make(Key)(Value)(Coh_map)
  include (D : module type of D with module Key := Key and module Value := Value)
  module Key = Key
  module Value = Value
end

module Derived = struct
module Make(Key:Pofable.S)(Value:Pofable.S)(Parent:Coh_object.T)
= struct
  module Parent = struct include Coh_map.Derived.Make(Key)(Value)(Parent) end
  include Derived.Make(Key)(Value)(Coh_map)
end
end
end
