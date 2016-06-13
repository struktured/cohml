module type S =
sig
  module T : Coh_object.T
  module Key : Coh_object.S
  module Value : Coh_object.S
  include module type of Coh_observable_map.Object.Derived.Make(Key)(Value)(T)
    with module Key := Key and module Value := Value and module Self.T = T
end

module Pof =
struct
module Make(Key:Pofable.S)(Value:Pofable.S) :
  module type of Coh_observable_map.Pof.Make(Key)(Value) with
  module Key = Key and
  module Value = Value =
struct
  module Key = Key
  module Value = Value
  module Parent = Coh_observable_map.Pof.Make(Key)(Value)
  include (Parent : module type of Parent with module Key := Key and module Value := Value)
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
include Opaque.I
