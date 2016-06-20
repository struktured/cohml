open Ctypes
open Foreign
open Coh_primitives
module type S =
sig
  include Coh_object.S
  module Element_type : Coh_object.S
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

module Make(Element_type:Coh_object.S) :
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

  module Sub_array = struct
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
