open Coh_primitives


module Make(Key:Pofable.S)(Value:Pofable.S) =
struct
module type S =
sig
  include Coh_map.S with module Key = Key and module Value = Value
end


end

