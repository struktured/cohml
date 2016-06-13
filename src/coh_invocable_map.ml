module type S =
sig
  module Key : Coh_object.S
  module Value  : Coh_object.S
  module Entry :
  sig
    include module type of Coh_map.Entry
      with module Key = Key and module Value = Value
  end
  include Coh_map.S with
    module Key = Key and
    module Value = Value and
    module Entry = Entry

module Keys : module type of Coh_collection.Make(Coh_map.Key)
module Invoke : functor (Result:Coh_object.S) ->
sig
  module Entry_processor : Coh_object.S (* TODO stub *)
  module Result = Result
  module Map : Coh_map.S with module Key = Key and module Value = Result
    val one : t ->
      Key.View.t -> Entry_processor.Handle.t -> Result.Holder.t

    val all : t ->
      Keys.Handle.t -> Entry_processor.Handle.t -> Map.View.t

    module Filter : Coh_filter.S (* TODO strongly type this *)

    val filter : t ->
      Filter.View.t -> Entry_processor.Handle.t -> Map.View.t
end
end
