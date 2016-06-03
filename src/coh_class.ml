module type S =
sig
  include Coh_object.S
  val get_name : t -> string
end

