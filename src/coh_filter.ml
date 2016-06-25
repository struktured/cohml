module type S =
sig
  include Coh_object.S
  (* TODO *)
end

include Coh_object.Make(struct type t let name = "Filter" end)
let noop = failwith("nyi")

