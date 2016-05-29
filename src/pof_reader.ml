module type S =
sig
  type t
  val read_int32 : t -> index:int -> Int32.t
  val read_string : t -> index:int -> string
end

module External =
struct
  type t
  external read_int32 : t -> index:int -> Int32.t = "read_int32"
  external read_string : t -> index:int -> string = "read_string"
end

include External

