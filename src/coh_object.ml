open Coh_primitives
open Ctypes
open Foreign

module type T = sig val name : string type t end
module Create =
struct
module Self =
struct
module type S =
sig
  module T : T
  type t = T.t structure typ
  val name : string
  val t : t
  val get_method : string -> string
  val foreign : string -> ('a -> 'b) Ctypes.fn -> 'a -> 'b
end
module Make(T:T) : S with module T = T and type t = T.t structure typ =
struct
  module T = T
  type t = T.t structure typ
  let t : t = structure T.name
  let get_method meth = Printf.sprintf "%s_%s" T.name meth
  let foreign meth = Foreign.foreign (get_method meth)
  let name = T.name
end
end

module Pointer =
struct
module type S =
sig
  module Self : Self.S
  type t = Self.T.t structure ptr
  val t : t typ
  val name: string
end
module Make(T:T) :
  S with module Self.T = T (* and
  type Structure.t = T.t structure typ *) =
struct
  module Self = Self.Make(T)
  type t = T.t structure ptr
  let t = ptr Self.t
  let name = T.name
end
end

module Base : T =
struct
  let name = "Object"
  type t
end

module Obj = struct
include Self.Make(Base)
end


module View =
struct
  module type S =
  sig
    include Pointer.S
    val equals : t -> t -> bool
    val hash_code : t -> size32
    val is_immutable : t -> bool
    val size_of : t -> size32
  end
  module Make(T:T) : S with module Self.T = T =
  struct
    module Pointer_t = Pointer.Make(T)
    include (Pointer_t : Pointer.S with module Self.T = T)
    let equals : t -> t -> bool =
      Obj.foreign "equals" (t @-> t @-> returning bool)
    let hash_code : t -> size32 =
      Obj.foreign "hash_code" (t @-> returning int)
    let is_immutable =
      Obj.foreign "is_immutable" (t @-> returning bool)
    let size_of =
      Obj.foreign "size_of" (t @-> returning int)
  end
end

module Handle =
struct
  module type S =
  sig
    include View.S
    module View : View.S
    val clone : t -> t
  end
  module Make(T:T) : S with module Self.T = T =
  struct
    module View = View.Make(T)
    include View
    let clone = Obj.foreign
      "clone" (t @-> returning t)
  end
end

module Holder =
struct
module type S =
sig
  include Handle.S
  module Handle : Handle.S
  val to_handle : t -> Handle.t
end
module Make(T:T) : S with module Self.T = T =
struct
  module Handle = Handle.Make(T)
  include Handle
  let to_handle t = t
end
end

module Object =
struct
module type S =
sig
  include Holder.S
  module Holder : Holder.S
  val name : string
end

module Make(T:T) : S with module Self.T = T =
struct
  module T = T
  module Holder = Holder.Make(T)
  include Holder
end
end
end

module Make = Create.Object.Make
module Opaque = Make(Create.Obj)
include Opaque
module type S = Create.Object.S
