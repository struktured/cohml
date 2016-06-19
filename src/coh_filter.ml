module type S =
sig
  include Coh_object.S
  (* TODO *)
end

module I = struct include Coh_object.Opaque end

let noop = failwith("nyi")

