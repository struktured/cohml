open Ctypes
open Foreign
module type S =
sig
  module Result : Coh_object.S
  module Entry : Coh_entry.S
  module Map : Coh_map.S with module Value = Result and module Key = Entry.Key
  module Entries :
    sig
      include Coh_set.S with module Object = Entry
    end

  include Coh_object.S
  val process : Entry.Handle.t -> Result.Holder.t
  module All :
  sig
     val process : Entries.View.t -> Map.View.t
  end

end

module Make(Key:Coh_object.S)(Value:Coh_object.S)(Result:Coh_object.S) :
  S with module Entry.Key = Key and module Entry.Value = Value and module Result
  = Result =
struct
  module Result = Result
  module Entry = Coh_entry.Make(Key)(Value)
  module Map = Coh_map.Make(Entry.Key)(Result)
  module Entries = struct
    module Set = Coh_set.Make(Entry)
    include (Set : Coh_set.S with module Object := Entry)
    module Object = Entry
  end
  module T = struct type t let name = "EntryProcessor" end
  include Coh_object.Make(T)
  let process = Self.foreign "process" (Entry.Handle.t @-> returning
                                          Result.Holder.t)
  module All =
  struct
    let process = Self.foreign "process_all" (Entries.View.t @-> returning
                                                Map.View.t)
  end

end
