open Ctypes
open Foreign
open Coh_primitives
module type S =
sig
  include Coh_object.S
  val read_boolean : t -> index:int32 -> bool
  val read_octet : t -> index:int32 -> octet
  val read_char16 : t -> index:int32 -> char16
  val read_int16 : t -> index:int32 -> int16
  val read_int32 : t -> index:int32 -> int32
  val read_int64 : t -> index:int32 -> int64
  val read_float32 : t -> index:int32 -> float32
  val read_float64 : t -> index:int32 -> float64
  val read_boolean_array : t -> index:int32 -> Coh_array.Bool.t
  val read_char16_array : t -> index:int32 -> Coh_array.Char16.t
  val read_octet_array : t -> index:int32 -> Coh_array.Octet.t
  val read_int16_array : t -> index:int32 -> Coh_array.Int16.t
  val read_int32_array : t -> index:int32 -> Coh_array.Int32.t
  val read_int64_array : t -> index:int32 -> Coh_array.Int64.t
  val read_float32_array : t -> index:int32 -> Coh_array.Float32.t
  val read_float64_array : t -> index:int32 -> Coh_array.Float64.t
  val read_binary : t -> index:int32 -> Coh_binary.View.t
  val read_string : t -> index:int32 -> string
  (* TODO read date / time *)

  module Object :
  sig
    module Make : functor (Object:Coh_object.S) ->
    sig
      module Array : Coh_array.Object.S with module Element_type = Object
      val read : t -> index:int32 -> Object.View.t
      val read_array : t -> index:int32 -> Array.View.t
    end
  end

  val read_long_array : t -> index:int32 -> Coh_array.Long.t

  module Collection :
  sig
    module Make : functor(Collection : Coh_collection.S) ->
    sig
      (* TODO Can class be infered through object functor ? *)
      val read : ?element_class:Coh_class.View.t -> t ->
        index:int32 -> Collection.View.t
    end
  end

  module Map :
  sig
    module Make : functor(Map : Coh_map.S) ->
    sig
    (* TODO Can class be infered through object functor ? *)
      val read : ?key_class:Coh_class.View.t ->
        ?value_class:Coh_class.View.t -> t -> index:int32 -> Map.View.t
    end
  end

  val get_pof_context : t -> Pof_context.View.t
  val set_pof_context : t -> Pof_context.View.t -> t
  val get_user_type_id : t -> int32
  val get_version_id : t -> int32
  val create_nested : t -> index:int32 -> Handle.t
  val read_remainder : t -> Coh_binary.View.t
end

module I : S =
struct
  include Coh_object.Make(struct type t let name = "PofReader" end)
module Foreign =
struct
  let to_labeled_index f = fun t ~index -> f t index
  let read_boolean = Self.foreign "read_boolean"
      (t @-> Int32.t @-> returning Bool.t) |> to_labeled_index
  let read_octet = Self.foreign "read_octet"
      (t @-> Int32.t @-> returning Octet.t) |> to_labeled_index
  let read_char16 = Self.foreign "read_char16"
      (t @-> Int32.t @-> returning Char16.t) |> to_labeled_index
  let read_int16 = Self.foreign "read_int16" 
      (t @-> Int32.t @-> returning Int16.t) |> to_labeled_index
  let read_int32 = Self.foreign "read_int32"
      (t @-> Int32.t @-> returning Int32.t) |> to_labeled_index
  let read_int64 =Self.foreign "read_int64"
      (t @-> Int32.t @-> returning Int64.t) |> to_labeled_index
  let read_float32 = Self.foreign "read_float32_array"
      (t @-> Int32.t @-> returning Float32.t) |> to_labeled_index
  let read_float64 = Self.foreign "read_float64_array"
      (t @-> Int32.t @-> returning Float64.t) |> to_labeled_index
  let read_boolean_array = Self.foreign "read_boolean_array"
      (t @-> Int32.t @-> returning Coh_array.Bool.t) |> to_labeled_index
  let read_char16_array = Self.foreign "read_char16_array"
      (t @-> Int32.t @-> returning Coh_array.Char16.t) |> to_labeled_index
  let read_octet_array = Self.foreign "read_octet_array"
      (t @-> Int32.t @-> returning Coh_array.Octet.t) |> to_labeled_index
  let read_int16_array = Self.foreign "read_int16_array"
      (t @-> Int32.t @-> returning Coh_array.Int16.t) |> to_labeled_index
  let read_int32_array = Self.foreign "read_int32_array"
      (t @-> Int32.t @-> returning Coh_array.Int32.t) |> to_labeled_index
  let read_int64_array = Self.foreign "read_int64_array"
      (t @-> Int32.t @-> returning Coh_array.Int64.t) |> to_labeled_index
  let read_float32_array = Self.foreign "read_float32_array"
      (t @-> Int32.t @-> returning Coh_array.Float32.t) |> to_labeled_index
  let read_float64_array = Self.foreign "read_float64_array"
      (t @-> Int32.t @-> returning Coh_array.Float64.t) |> to_labeled_index
  let read_binary = Self.foreign "read_binary"
      (t @-> Int32.t @-> returning Coh_binary.View.t) |> to_labeled_index
  let read_string = Self.foreign "read_string"
      (t @-> Int32.t @-> returning String.t) |> to_labeled_index
  let read_long_array = Self.foreign "read_long_array"
      (t @-> Int32.t @-> returning Coh_array.Long.t) |> to_labeled_index
end
include Foreign

module Object =
struct
  module Make (Object:Coh_object.S) =
  struct
    module Array = Coh_array.Object.Make(Object)
    module Foreign =
    struct
      let read = Self.foreign "read_object"
        (t @-> Int32.t @-> returning Object.View.t) |> to_labeled_index
      let read_array = Self.foreign "read_object_array"
        (t @-> Int32.t @-> returning Array.View.t) |> to_labeled_index
    end
    include Foreign
  end
end

module Collection =
struct
  module Make (Collection:Coh_collection.S) =
  struct
    module Foreign =
    struct
      let read = Self.foreign "read_collection"
        (Coh_class.View.t_opt @-> t @-> Int32.t @->
         returning Collection.View.t) |>
        fun f ?element_class t ~index -> f element_class t index
    end
    include Foreign
  end
end

module Map =
struct
  module Make (Map:Coh_map.S) =
  struct
    module Foreign =
    struct
      let read = Self.foreign "read_map"
        (Coh_class.View.t_opt @-> Coh_class.View.t_opt @-> t
         @-> Int32.t @-> returning Map.View.t) |>
      fun f ?key_class ?value_class t ~index -> f key_class value_class t index
    end
    include Foreign
  end
end

let get_pof_context = Self.foreign "get_pof_context"
    (t @-> returning Pof_context.View.t)
let set_pof_context = Self.foreign "set_pof_context"
    (t @-> Pof_context.View.t @-> returning t)
let get_user_type_id = Self.foreign "get_user_type_id"
    (t @-> returning Int32.t)
let get_version_id = Self.foreign "get_version_id"
    (t @-> returning Int32.t)
let create_nested = Self.foreign "create_nested"
    (t @-> Int32.t @-> returning Handle.t) |> to_labeled_index
let read_remainder = Self.foreign "read_remainder"
    (t @-> returning Coh_binary.View.t)

end
include I
