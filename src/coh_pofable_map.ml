open Coh_primitives

module type S =
sig
  module Key : Pofable.S
  module Value : Pofable.S
  include Coh_map.S with module Key := Key and module Value := Value
end

module Make(Key:Pofable.S)(Value:Pofable.S) 
  : S with module Key = Key and module Value = Value =
struct
module type S =
sig
  include S with module Key = Key and module Value = Value
end

module Parent = Coh_map.Make(Key)(Value)
module Key = Key
module Value = Value
include (Parent : S with module Key := Key and module Value := Value)
end

