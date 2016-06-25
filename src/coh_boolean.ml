open Ctypes
    open Foreign

module type S =
sig

end

module Object =
struct
  include Coh_object.Make(struct type t let name = "Boolean" end)
end
