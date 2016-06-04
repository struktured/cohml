module type S =
sig
include Coh_map.S
module Keys : Coh_set.S with module Object = Key
module Entries : Coh_set.S with module Object = Entry
module Entry_compare : Coh_comparator.S with module Object = Entry
module Filter : Coh_filter.S
module Value_extractor : Coh_value_extractor.S

val key_set : ?filter:Filter.View.t -> t -> Keys.View.t

val entry_set : ?compare:Entry_compare.View.t -> ?filter:Filter.View.t ->
  t -> Entries.View.t

val add_index :
  ?compare:Entry_compare.t -> Value_extractor.t -> ordered:bool -> t

val remove_index : t -> Value_extractor.t -> t
end

module Make_derived(Key:Pofable.S)(Value:Pofable.S)(I:Coh_object.S) : S with module Key = Key and module Value = Value 
and type t = I.t =
struct
  module Map = Coh_map.Make_derived(Key)(Value)(I)
  include Map
  module Keys = Coh_set.Pof(Map.Key)
  module Entries = struct
    include (Coh_set.Pof(Map.Entry) : Coh_set.S with module Object := Map.Entry)
    module Object = Map.Entry
  end
  module Entry_compare = 
    struct 
      include (Coh_comparator.Make(Map.Entry) : Coh_comparator.S with module Object := Map.Entry)
      module Object = Map.Entry
    end

  module Filter = Coh_filter.I (* TODO *)
  module Value_extractor = Coh_value_extractor.I (* TODO *)
  let key_set ?filter t = failwith("nyi")
  let entry_set ?compare ?filter t = failwith("nyi")
  let add_index ?compare value_extractor ~ordered = failwith("nyi")
  let remove_index t value_extractor = failwith("nyi")
end

module Make(Key:Pofable.S) (Value:Pofable.S) :
  S with module Key = Key and module Value = Value =
  struct
    include Make_derived(Key)(Value)(Coh_object.Opaque)
  end
