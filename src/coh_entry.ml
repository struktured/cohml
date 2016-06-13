open Ctypes
open Foreign

module type S =
  sig
    module Key : Coh_object.S
    module Value : Coh_object.S
    include Coh_object.S
    val get_key : t -> Key.View.t
    val get_value : t -> Value.Holder.t option
    val set_value : t -> Value.Holder.t -> Value.Holder.t option
  end

module Make(Key:Coh_object.S)(Value:Coh_object.S) :
  S with module Key = Key and module Value = Value =
struct
  module Key = Key
  module Value = Value
  include Coh_object.Make(struct type t let name = "entry" end)
  let get_key = Self.foreign "get_key" (t @-> returning Key.View.t)
  let get_value = Self.foreign "get_value"
    (t @-> returning @@ ptr_opt Value.Holder.Self.t)
  let set_value = Self.foreign "set_value" (t @-> Value.Holder.t @->
    returning @@ ptr_opt Value.Holder.Self.t)
end

