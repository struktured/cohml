open Coh_primitives
module type S =
sig
  include Coh_object.S
  module Object : Coh_object.S
  val compare : t -> Object.View.t -> Object.View.t -> coh_int32
end

