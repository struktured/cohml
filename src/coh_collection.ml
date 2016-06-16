open Coh_primitives
open Ctypes
open Foreign

module type S =
sig
include Coh_object.S
module Object : Coh_object.S
module Iterator : Coh_iterator.S with module Object = Object
val size : t -> size32
val is_empty : t -> bool
val contains : t -> Object.View.t -> bool
val contains_all : t -> View.t -> bool
val iterator : t -> Iterator.Handle.t
end

module Derived =
struct
module Make(Object : Coh_object.S)(T:Coh_object.T) : S with module Object = Object =
struct
  include Coh_object.Make(T)
  module Object = Object
  module Iterator = Coh_iterator.Make(Object)
  let size = Self.foreign "size" (t @-> returning int)
  let is_empty = Self.foreign "is_empty" (t @-> returning bool)
  let contains = Self.foreign "contains" (t @-> Object.View.t @-> returning bool)
  let contains_all = Self.foreign "contains_all" (t @-> View.t @-> returning bool)
  let iterator = Self.foreign "iterator" (t @-> returning Iterator.Handle.t)
end
end

module Make(Object : Coh_object.S) : S with module Object = Object =
struct
  include Derived.Make(Object)(struct type t let name = "collection" end)
end
include Make(Coh_object.Opaque)


