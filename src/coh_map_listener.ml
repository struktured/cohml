module type S =
sig
    include module type of Coh_observable_map.Map_listener
    module Map_event : Coh_map_event.S
    type entry_fun = Map_event.View.t -> unit
    val entry_inserted : t -> entry_fun
    val entry_updated : t -> entry_fun
    val entry_deleted : t -> entry_fun
end

module Make(Map_event:Coh_map_event.S) : S with module Map_event = Map_event =
  struct
  open Ctypes
  open Foreign
  module Map_event = Map_event
  type entry_fun = Map_event.View.t -> unit
  let entry_fun = Map_event.View.t @-> returning void
  let no_op : entry_fun = fun _ -> ()
  include Coh_observable_map.Map_listener
  module Foreign =
  struct
    let create = Self.foreign "create" @@
      funptr entry_fun @->
      funptr entry_fun @->
      funptr entry_fun @->
      returning t
    let entry_inserted = Self.foreign "entry_inserted" (t @-> returning (funptr entry_fun))
    let entry_updated = Self.foreign "entry_updated" (t @-> returning (funptr entry_fun))
    let entry_deleted = Self.foreign "entry_deleted" (t @-> returning (funptr entry_fun))
  end

  let create ?(entry_inserted=no_op) ?(entry_updated=no_op) ?(entry_deleted=no_op) () =
    Foreign.create entry_inserted entry_updated entry_deleted
  let entry_inserted = Foreign.entry_inserted
  let entry_updated = Foreign.entry_updated
  let entry_deleted = Foreign.entry_deleted
end

