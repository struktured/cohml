module type S =
sig
  include Coh_collection.S
end

module Make_derived(Object : Coh_object.S)(I:Coh_object.S) : S with module Object = Object =
struct
  include Coh_collection.Make_derived(Object)(I)
end

module Make(Object : Coh_object.S) : S with module Object = Object =
struct
  include Coh_collection.Make_derived(Object)(Coh_object.Opaque)
end

module Pof_derived(Object:Pofable.S)(I:Coh_object.S) :
S with module Object = Object =
struct
  include Coh_collection.Pof_derived(Object)(I)
end

module Pof(Object:Pofable.S) : S with module Object = Object =
struct
    include (Pof_derived(Object)(Coh_object.Opaque) : S with module Object = Object)
end
