module type S =
sig
include Coh_map.S
module Map_listener : Coh_object.S
module Filter : Coh_filter.S
val add_key_listener : t ->
  ?lite:bool -> Map_listener.Handle.t -> Key.View.t -> t
val remove_key_listener : t -> 
  Map_listener.Handle.t -> t
val add_filter_listener : t ->
  ?lite:bool -> ?filter:Filter.View.t -> Map_listener.Handle.t -> t
val remove_filter_listener : t ->
  ?filter:Filter.View.t -> Map_listener.Handle.t -> t
end

