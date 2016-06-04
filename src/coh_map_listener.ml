module type S =
  sig
    include Coh_object.S
    module Map_event : Coh_map_event
    val entry_inserted : Map_event.View.t -> unit
    val entry_updated : Map_event.View.t -> unit
    val entry_deleted : Map_event.View.t -> unit
  end

