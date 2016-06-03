open Coh_primitives
module type HANDLE =
sig
  type t
end

module type VIEW =
sig
  type t
end

module type HOLDER =
sig
  module Handle : HANDLE
  module View : VIEW
  include VIEW
  val to_handle : t -> Handle.t
end

module type S =
sig
  module Handle : HANDLE
  module View : VIEW
  module Holder : HOLDER
  type t
  val equals : t -> View.t -> bool
  val clone :  t -> Handle.t
  val hash_code : t -> size32
  val is_immutable : t -> bool
  val size_of : t -> size32
end

module Make(M:sig type t end) =
struct
  include M
  module Handle = M
  module View = M
  module Holder = M
end

