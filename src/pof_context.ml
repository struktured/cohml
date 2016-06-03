module type S =
sig
  type t

end

module type SYSTEM =
sig
  include S
  val register : t -> user_type:int -> View.t -> t
end



