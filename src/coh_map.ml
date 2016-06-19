open Coh_primitives
open Ctypes
open Foreign

module type S =
sig
  include Coh_object.S
  module Key : Coh_object.S
  module Value : Coh_object.S
  module Entry : Coh_entry.S with
    module Key = Key and module Value = Value
  val size : t -> size32
  val is_empty : t -> bool
  val contains_key : t -> Key.View.t -> bool
  val contains_value : t -> Value.Holder.t -> bool
  val get : t -> Key.View.t -> Value.Holder.t option
  val put : t -> Key.View.t -> Value.Holder.t -> Value.Holder.t option
  val remove : t -> Key.View.t -> Value.Holder.t option
  val put_all : t -> to_put:t -> t
end

module Derived = struct
module Make(Key:Coh_object.S)(Value:Coh_object.S)(T:Coh_object.T) :
S with module Key = Key and module Value = Value and module Self.T = T =
struct
  module Key = Key
  module Value = Value
  include Coh_object.Make(T)
  module Entry = Coh_entry.Make(Key)(Value)

  module Foreign = struct
  let size = Self.foreign "size"
      (t @-> returning int)
  let is_empty = Self.foreign "is_empty"
      (t @-> returning bool)
  let contains_key = Self.foreign "contains_key"
      (t @-> Key.View.t @-> returning bool)
  let contains_value = Self.foreign "contains_value"
      (t @-> Value.Holder.t @-> returning bool)
  let get = Self.foreign "get"
      (t @-> Key.View.t @-> returning Value.Holder.t_opt)
  let put = Self.foreign "put"
      (t @-> Key.View.t @-> Value.Holder.t @-> returning Value.Holder.t_opt)
  let remove = Self.foreign "remove"
      (t @-> Key.View.t @-> returning Value.Holder.t_opt)
  let put_all = Self.foreign "put_all"
      (t @-> t @-> returning t)
  end
  include Foreign
  let put_all t ~to_put = put_all t to_put
end (* Derived.Make *)
end (* Derived *)
module Make(Key:Coh_object.S)(Value:Coh_object.S) =
  Derived.Make(Key)(Value)(struct type t let name = "Map" end)

include Make(Coh_object)(Coh_object)
