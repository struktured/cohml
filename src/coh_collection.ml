open Coh_primitives
module type S =
sig
include Coh_object.S
module Object : Coh_object.S
module Iterator : Coh_iterator.S with module Object = Object
val size : t -> size32
val is_empty : t -> bool
val contains : t -> Object.View.t -> bool
val contains_all : t -> View.t -> bool
val iterator : t -> Iterator.Handle.t
end

module Make_derived(Object : Coh_object.S)(I:Coh_object.S) : S with module Object = Object =
struct
  include I
  module Object = Object
  module Iterator = Coh_iterator.Make(Object)
  let size t = failwith("nyi")
  let is_empty t = failwith("nyi")
  let contains t = failwith("nyi")
  let contains_all t = failwith("nyi")
  let iterator t = failwith("nyi")
end

module Make(Object : Coh_object.S) : S with module Object = Object =
struct
  include Make_derived(Object)(Coh_object.Opaque)
end

module Pof_derived(Object:Pofable.S)(I:Coh_object.S) :
S with module Object = Object =
struct
  module type S =
  sig
    include S with module Object = Object
  end

  module I : S = struct
    module Collection = Make_derived(Object)(I)
    include (Collection : S with module Object := Object)
    module Object = Object
  end
  include I
end

module Pof(Object:Pofable.S) : S with module Object = Object =
struct
    include Pof_derived(Object)(Coh_object.Opaque)
end

