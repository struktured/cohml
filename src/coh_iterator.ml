module type S =
sig
  include Coh_object.S
  module Object : Coh_object.S
  val has_next : t -> bool
  val next : t -> Object.Holder.t
end

module Make(Object : Coh_object.S) :
  S with module Object = Object =
struct
  include Coh_object.Opaque
  module Object = Object
  let has_next t = failwith("nyi")
  let next t = failwith("nyi")
end
(*
module Pof(Object:Pofable.S) : S with module Object = Object =
struct

  module type S =
  sig
    include S with module Object = Object
  end

  module I : S =
  struct
    module Iterator = Make(Object)
    include (Iterator : S with module Object := Object)
    module Object = Object
  end
  include I
end
*)
