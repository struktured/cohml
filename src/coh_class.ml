module type S =
sig
  include Coh_object.S
  val get_name : t -> string
end

module I : S = struct
  include Coh_object.Opaque
  let get_name t = failwith("nyi")
end

include I


