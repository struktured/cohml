type size32 = int
type int32 = int
type char16 = char (** TODO ?? *)
type int16 = int
type int64 = int
type float32 = float
type float64 = float
type octet = int (* TODO ?? *)
type long = int64

open Ctypes
open Foreign

module Bool =
struct
  type t = bool let t = bool
end

module Int =
struct
  type t = int let t = int
end

module Float =
struct
  type t = float let t = float
end

module Char =
struct
  type t = char let t = char
end

module String =
struct
type t = string let t = string
end

module Size32 = Int
module Char16 = Char
module Int16 = Int
module Int32 = Int
module Int64 = Int
module Float32 = Float
module Float64 = Float
module Octet = Int
module Long = Int64
