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

include Make(Coh_object.Opaque)
