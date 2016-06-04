module type S =
sig
include Coh_map.S
module Keys : Coh_set.S with module Object = Key
module Entries : Coh_set.S with module Object = Entry
module Entry_compare : Coh_comparator.S with module Object = Entry
module Filter : Coh_filter.S
module Value_extractor : Coh_value_extractor.S
val key_set : t -> Filter.View.t -> Keys.View.t
val entry_set : t ->
  ?compare:Entry_compare.View.t -> Filter.View.t -> Entries.View.t
val add_index : t ->
  ?compare:Entry_compare.t -> Value_extractor.t -> ordered:bool -> t
val remove_index : t -> Value_extractor.t -> t
end

