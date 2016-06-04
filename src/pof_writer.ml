open Coh_primitives
module type S =
sig
  type t
  val write_boolean : t -> index:int32 -> bool -> t
  val write_octet : t -> index:int32 -> octet -> t
  val write_char16 : t -> index:int32 -> char16 -> t
  val write_int16 : t -> index:int32 -> int16 -> t
  val write_int32 : t -> index:int32 -> int32 -> t
  val write_int64 : t -> index:int32 -> int64 -> t
  val write_float32 : t -> index:int32 -> float32 -> t
  val write_float64 : t -> index:int32 -> float64 -> t
  val write_boolean_array : t -> index:int32 -> bool array -> t
  val write_char16_array : t -> index:int32 -> char16 array -> t
  val write_octet_array : t -> index:int32 -> octet array -> t
  val write_int16_array : t -> index:int32 -> int16 array -> t
  val write_int32_array : t -> index:int32 -> int32 array -> t
  val write_int64_array : t -> index:int32 -> int64 array -> t
  val write_float32_array : t -> index:int32 -> float32 array -> t
  val write_float64_array : t -> index:int32 -> float64 array -> t
  val write_binary : t -> index:int32 -> Coh_binary.View.t -> t
  val write_string : t -> index:int32 -> string -> t
  (* TODO write date / time *)
  val write_object : t -> index:int32 -> Coh_object.View.t -> t
  val write_object_array : t -> index:int32 -> Coh_object.View.t array -> t

end

module External =
struct
  type t
  external write_int32 : t -> index:int32 -> int32 -> t = "write_int32"
  external write_string : t -> index:int32 -> string -> t = "write_string"
end

include External

