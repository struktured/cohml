module type S =
sig
  include Coh_object.S
  module Value : Coh_object.S
  val has_next : t -> bool
  val next : t -> Value.Holder.t
end
