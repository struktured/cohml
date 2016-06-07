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
  val read_boolean_array : t -> index:int32 -> bool array
  val read_char16_array : t -> index:int32 -> char16 array
  val read_octet_array : t -> index:int32 -> octet array
  val read_int16_array : t -> index:int32 -> int16 array
  val read_int32_array : t -> index:int32 -> int32 array
  val read_int64_array : t -> index:int32 -> int64 array
  val read_float32_array : t -> index:int32 -> float32 array
  val read_float64_array : t -> index:int32 -> float64 array
  val read_binary : t -> index:int32 -> Coh_binary.View.t
  val read_string : t -> index:int32 -> string
  (* TODO read date / time *)

  module Objects : functor (Object:Coh_object.S) ->
  sig
    val read_object : t -> index:int32 -> Object.View.t
    val read_object_array : t -> index:int32 -> Object.View.t array
  end
  val read_long_array : t -> index:int32 -> long array

  module Collections : functor(Collection : Coh_collection.S) ->
  sig
    (* TODO Can class be infered through object functor ? *)
    val read_collection : ?element_class:Coh_class.View.t -> t ->
      index:int32 -> Collection.View.t
  end

  module Maps : functor(Map : Coh_map.S) ->
  sig
    (* TODO Can class be infered through object functor ? *)
    val read_map : ?key_class:Coh_class.View.t ->
      ?value_class:Coh_class.View.t -> t -> index:int32 -> Map.t
  end
  val get_pof_context : t -> Pof_context.View.t
  val set_pof_context : t -> Pof_context.View.t -> t
  val get_user_type_id : t -> int32
  val get_version_id : t -> int32
  val create_nested : t -> index:int32 -> Handle.t
  val read_remainder : t -> Coh_binary.View.t
end

module External =
struct
  type t
  external read_int32 : t -> index:int -> Int32.t = "read_int32"
  external read_string : t -> index:int -> string = "read_string"
end
include External

