open Coh_primitives
module type S =
sig
  include Coh_object.S
  module Key : Pofable.S
  module Value : Pofable.S
  module Observable_map : Coh_observable_map.S with
    module Key = Key and module Value = Value
  val get_map : t -> Observable_map.Handle.t
  val get_id : t -> coh_int32
  val get_key : t -> Key.View.t
  val get_old_value : t -> Value.View.t option
  val get_new_value : t -> Value.View.t option
  (* TODO toStream and dispatch *)
  val get_description : t -> string
end

