module type S =
sig
  type t

end

module type SYSTEM =
sig
  include S
  module Coh_class : Coh_class.S
  val register : t -> user_type:int -> Coh_class.View.t -> t
end



