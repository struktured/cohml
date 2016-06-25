open Ctypes
open Foreign

module type S =
sig
  include Coh_object.S
  val get_name : t -> string
end

module Object : S = struct
  include Coh_object.Make(struct type t let name = "Class" end)
      module Foreign = struct
        let get_name = Self.foreign "get_name"
            (t @-> returning string)
      end
      include Foreign
end

include Object


