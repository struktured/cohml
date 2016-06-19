open Ctypes
open Foreign
open Coh_primitives
module type S =
sig
  include Coh_object.S with module Self = Coh_observable_map.Map_event.Self
  module Map : Coh_observable_map.S
  val get_map : t -> Map.Handle.t
  val get_id : t -> int32
  val get_key : t -> Map.Key.View.t
  val get_old_value : t -> Map.Value.View.t option
  val get_new_value : t -> Map.Value.View.t option
  (* TODO toStream and dispatch *)
  val get_description : t -> string
end

module Make(Map:Coh_observable_map.S) : S with module Map = Map =
struct
  include Coh_observable_map.Map_event
  module Map = Map
  let get_map = Self.foreign "get_map" (t @-> returning Map.Handle.t)
  let get_id = Self.foreign "get_id" (t @-> returning int)
  let get_key = Self.foreign "get_key" (t @-> returning Map.Key.View.t)
  let get_old_value = Self.foreign "get_old_value" (t @-> returning Map.Value.View.t_opt)
  let get_new_value = Self.foreign "get_new_value" (t @-> returning Map.Value.View.t_opt)
  let get_description = Self.foreign "get_description" (t @-> returning string)
end


