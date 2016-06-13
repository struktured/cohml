module type S =
sig
  module Result : Coh_object.S
  module Entry : Coh_entry.S
  module Map : Coh_map.S with module Value = Result and module Key = Entry.Key
  module Entries : Coh_set.S with module Object = Entry
  include Coh_object.S 
  val process : Entry.Handle.t -> Result.Holder.t
  module All : 
  sig
     val process : Entries.View.t -> Map.View.t
  end

end

module Make(Key:Coh_object.S)(Value:Coh_object.S)(Result:Coh_object.S) =
struct
  module Result = Result
  module Map = Coh_map.Make(Key)(Value)
  module Entries = Coh_set.Make(Map.Entry)
  module T = struct type t let name = "entry_processor" end
  include Coh_object.Make(T)
end
