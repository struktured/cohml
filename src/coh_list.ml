open Coh_primitives
module type S = sig
include Coh_collection.S
module Coh_collection : Coh_collection.S
val add : t -> size32 -> Object.Holder.t -> bool
val add_all : t -> size32 -> Coh_collection.View.t -> bool
val get : t -> size32 -> Object.Holder.t option
val index_of : t -> Object.View.t -> int option
val last_index_of : t -> Object.View.t -> int option

(*  TODO list iterator and muterators (from oracle list documentation:)
virtual
ListIterator::Handle 	listIterator (size32_t i=0) const =0
 	Return a ListIterator for this list starting at index.
virtual
ListMuterator::Handle 	listIterator (size32_t i=0)=0
 	Return a ListIterator for this list starting at index. *)

val remove : t -> size32 -> Object.Holder.t option
val set : t -> size32 -> Object.Holder.t -> Object.Holder.t option
val sub_list_view : t -> int -> int -> View.t
val sub_list_handle : t -> int -> int -> Handle.t
end

