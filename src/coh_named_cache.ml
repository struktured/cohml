module type S =
sig
  module I : Coh_object.T
  module Key : Coh_object.S
  module Value : Coh_object.S
  include Coh_observable_map.Derived.Make(Key)(Value).S
end


module Derived =
struct
module Make(Map:Coh_observable_map.S) : S =
struct
  include Map
end
end


module Pof =
struct
module Make(Key:Pofable.S)(Value:Pofable.S) : module type of Coh_observable_map.Object.Make(Key)(Value) with module Key = Key and module Coh_map.Key = Key
   (*:
  S with module Key = Key and module Value = Value =*) =
struct
  include Coh_observable_map.Pof.Make(Key)(Value)
end
end

module Object =
struct
module Make(Key:Coh_object.S)(Value:Coh_object.S) =
struct
  include Coh_observable_map.Object.Make(Key)(Value)
end
end

module Make = Object.Make
module Opaque = Make(Coh_object.Opaque)(Coh_object.Opaque)
include Opaque
