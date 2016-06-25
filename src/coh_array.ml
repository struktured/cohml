open Ctypes
open Foreign
open Coh_primitives
module type S =
sig
  include Coh_object.S
  module Element_type : sig type t val t : t typ end
  val size_of : t -> size32
  val get : t -> int32 -> Element_type.t
  val to_array : t -> Element_type.t array
  module Sub_array :
  sig
    module Handle :
    sig
      val from_range : t -> int32 -> int32 -> Handle.t
    end

    module View :
    sig
      val from_range : t -> int32 -> int32 -> View.t
    end
  end
end

module Make(Element_type:sig type t val t : t typ end) :
  S with module Element_type = Element_type =
struct
  include Coh_object.Make(struct type t let name = "Array" end)
  module Element_type = Element_type
  module Foreign =
  struct
    let get = Self.foreign "get"
        (t @-> int @-> returning Element_type.t)
    let sub_array_as_handle = Self.foreign "sub_array_as_handle"
        (t @-> int @-> int @-> returning Handle.t)
    let sub_array_as_view = Self.foreign "sub_array_as_view"
        (t @-> int @-> int @-> returning View.t)
  end
  include Foreign

  let to_array t =
    let len = size_of t in 
    if len = 0 then Array.of_list [] else
    let first = get t 0 in
    let arr = Array.make len first in
    for i = 1 to len do
      Array.set arr i (get t i)
    done;
    arr

  module Sub_array =
  struct
    module Handle =
    struct
      let from_range = sub_array_as_handle
    end

    module View =
    struct
      let from_range = sub_array_as_view
    end
  end
end

module Bool = Make(Coh_primitives.Bool)
module Int = Make(Coh_primitives.Int)
module Float = Make(Coh_primitives.Float)
module Char = Make(Coh_primitives.Char)
module String = Make(Coh_primitives.String)
module Char16 = Make(Coh_primitives.Char16)
module Int16 = Make(Coh_primitives.Int16)
module Int32 = Make(Coh_primitives.Int32)
module Int64 = Make(Coh_primitives.Int64)
module Float32 = Make(Coh_primitives.Float32)
module Float64 = Make(Coh_primitives.Float64)
module Octet = Make(Coh_primitives.Octet)
module Long = Make(Coh_primitives.Long)

module Object =
struct
module type S = 
sig
  module Element_type : Coh_object.S
  include S with module Element_type := Element_type
end
module Make(Element_type:Coh_object.S) : S with module Element_type = Element_type =
struct
module Element_type = Element_type
module Array = Make(Element_type)
include (Array : S with module Element_type := Element_type)
end
end

