module type S =
sig
  include Coh_serializer.S
end

module System =
struct
module type S =
sig
  include S
  module Coh_class : Coh_class.S
  val register : t -> user_type:int -> Coh_class.View.t -> t
end
module I : S =
struct
  include Coh_object.Make(struct type t let name = "PofContext" end)
  module Coh_class = Coh_class
  let register t  ~user_type coh_class = failwith("nyi")
end
include I
end

include System.I


