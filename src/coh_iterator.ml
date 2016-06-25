open Ctypes
open Foreign

module type S =
sig
  include Coh_object.S
  module Object : Coh_object.S
  val has_next : t -> bool
  val next : t -> Object.Holder.t
end

module Make(Object : Coh_object.S) :
  S with module Object = Object =
struct
  include Coh_object.Make(struct type t let name = "iterator" end)
  module Object = Object
  let has_next = Self.foreign "has_next" (t @-> returning bool)
  let next = Self.foreign "next" (t @-> returning Object.Holder.t)
end

