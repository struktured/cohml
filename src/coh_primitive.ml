open Ctypes
open Foreign

module type S =
sig
  include Coh_object.S
  module Boxed_type : sig type t val t : t typ end
  val get_value : t -> Boxed_type.t
end

module Derived =
struct
module Make(Boxed_type:sig type t val t : t typ end)(T:Coh_object.T) :
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


module Make(Boxed_type:sig type t val t : t typ end) :
  S with module Boxed_type = Boxed_type =
struct
  include Derived.Make(Boxed_type)(struct type t let name = "Primitive" end)
end


