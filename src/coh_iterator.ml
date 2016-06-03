module type S =
sig
  include Coh_object.S
  module Object : Coh_object.S
  val has_next : t -> bool
  val next : t -> Object.Holder.t
end
