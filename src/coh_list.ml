open Ctypes
open Foreign

open Coh_primitives
module type S = sig
include Coh_collection.S
val add : t -> size32 -> Object.Holder.t -> bool
module All : functor(Collection:Coh_collection.S with module Object = Object) ->
sig
val add : t -> size32 -> Collection.View.t -> bool
end
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

module Derived =
struct
module Make(Object : Coh_object.S)(T:Coh_object.T) :
  S with module Object = Object =
struct
  let to_int_option = function x when x < 0 -> None | x -> Some x

  include Coh_collection.Derived.Make(Object)(T)
  let add = Self.foreign "add" (t @-> int @-> Object.Holder.t @-> returning bool)
  module All(Collection:Coh_collection.S with module Object = Object) =
  struct
    let add =  Self.foreign "add_all" (t @-> int @-> Collection.View.t @-> returning bool)
  end
  let get = Self.foreign "get" (t @-> int @->  returning Object.Holder.t_opt)
  let index_of o x = Self.foreign "index_of" (t @-> Object.View.t @-> returning @@ int) o x |> to_int_option
  let last_index_of o x = Self.foreign "last_index_of" (t @-> Object.View.t @-> returning @@ int) o x 
     |> to_int_option
  let remove = Self.foreign "remove" (t @-> int @-> returning Object.Holder.t_opt)
  let set = Self.foreign "set" (t @-> int @-> Object.Holder.t @-> returning Object.Holder.t_opt)
  let sub_list_view = Self.foreign "sub_list_view" (t @-> int @-> int @-> returning View.t)
  let sub_list_handle = Self.foreign "sub_list_handle" (t @-> int @-> int @-> returning Handle.t)
end
end

module Make(Object : Coh_object.S) : S with module Object = Object =
struct
  include Derived.Make(Object)(struct type t let name = "List" end)
end

include Make(Coh_object.Opaque)
