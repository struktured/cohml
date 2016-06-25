open Ctypes
open Foreign

module type BOXED_TYPE =
sig
type t
val t : t typ
end

module type S =
sig
  include Coh_object.S
  module Boxed_type : BOXED_TYPE
  val get_value : t -> Boxed_type.t
end

module Derived =
struct
module Make(Boxed_type : BOXED_TYPE)(T:Coh_object.T) :
  S with module Boxed_type = Boxed_type =
struct
  include Coh_object.Make(T)
  module Boxed_type = Boxed_type
  module Foreign =
  struct
    let get_value : t -> Boxed_type.t =
      Self.foreign "get_value" (t @-> returning Boxed_type.t)
  end
  include Foreign
end
end

module Make(Boxed_type : BOXED_TYPE) :
  S with module Boxed_type = Boxed_type =
struct
  include Derived.Make(Boxed_type)(struct type t let name = "Primitive" end)
end

module Boolean =
struct
  include Make(struct type t = bool let t = bool end)
end

module Integer = Make(Coh_primitives.Int)

module Float = Make(Coh_primitives.Float)

module Char = Make(Coh_primitives.Char)

module String = Make(Coh_primitives.String)
