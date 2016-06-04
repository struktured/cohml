module Make(Key:Pofable.S)(Value:Pofable.S) =
struct
  include Coh_observable_map.Make(Key)(Value)
end
