module type S =
sig
  include Coh_object.S

  module Cache : sig
  module Object : sig
  module Make : functor (Key:Coh_object.S)(Value:Coh_object.S) ->
  sig
      module Named_cache : Coh_named_cache.S with module Key = Key and module Value = Value
      val get : cache_name:string -> unit -> Named_cache.Handle.t
      val destroy : Named_cache.Handle.t -> unit
      val release : Named_cache.Handle.t -> unit
  end
  end
  end

  val shutdown : unit -> unit
(* TODO static void 	configure (XmlElement::View vXmlCache, XmlElement::View vXmlCoherence=NULL)
    Configure the CacheFactory and local member. AND OTHERS! *)

end



