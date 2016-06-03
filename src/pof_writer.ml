module type S =
sig
  type t
  val write_int32 : t -> index:int -> Int32.t -> t
  val write_string : t -> index:int -> string -> t
end

module External =
struct
  type t
  external write_int32 : t -> index:int -> Int32.t -> t = "write_int32"
  external write_string : t -> index:int -> string -> t = "write_string"
end

include External

