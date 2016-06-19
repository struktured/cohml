open Ctypes
open Foreign
open Coh_primitives

module type S =
sig
  include Coh_object.S
  module Object : Coh_object.S
  val compare : t -> Object.View.t -> Object.View.t -> int32
end

module Make(Object:Coh_object.S) : S with module Object = Object =
struct
  include Coh_object.Make(struct type t let name = "Comparator" end)
  module Object = Object
  module Foreign =
  struct
    let compare = Self.foreign "compare"
        (t @-> Object.View.t @-> Object.View.t @-> returning int)
  end
  include Foreign
end

include Make(Coh_object)


