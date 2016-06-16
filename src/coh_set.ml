module type S =
sig
  include Coh_collection.S
end

module Derived =
struct
module Make(Object : Coh_object.S)(T:Coh_object.T) :
  S with module Object = Object =
struct
  include Coh_collection.Derived.Make(Object)(T)
end
end

module Make(Object : Coh_object.S) : S with module Object = Object =
struct
  include Coh_collection.Derived.Make(Object)(Coh_object.Opaque)
end

include Make(Coh_object.Opaque)
