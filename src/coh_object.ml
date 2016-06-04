open Coh_primitives

module type T = sig type t end
module I : T = struct type t end

module Create =
struct
module View =
struct
  module type S =
  sig
    include T
    val equals : t -> t -> bool
    val hash_code : t -> size32
    val is_immutable : t -> bool
    val size_of : t -> size32
  end
  module Make(I:T) : S with type t = I.t =
  struct
    include I
    let equals t t' = failwith("nyi")
    let hash_code t = failwith("nyi")
    let is_immutable t = failwith("nyi")
    let size_of t = failwith("nyi")
  end
end

module Handle =
struct
  module type S =
  sig
    include View.S
    module View : View.S
    val clone : t -> t
  end
  module Make(I:T) : S with type t = I.t =
  struct
    module View = View.Make(I)
    include View
    let clone t = failwith("nyi")
  end
end

module Holder =
struct
module type S =
sig
  include Handle.S
  module Handle : Handle.S
  val to_handle : t -> Handle.t
end
module Make(I:T) : S with type t = I.t =
struct
  module Handle = Handle.Make(I)
  include Handle
  let to_handle t = t
end
end

module Object =
struct
module type S =
sig
  include Holder.S
  module Holder : Holder.S
end

module Make(I:T) : S with type t = I.t =
struct
  module I = I
  module Holder = Holder.Make(I)
  include Holder
end
end
end

module Make = Create.Object.Make
module Opaque = Make(I)
include Opaque
module type S = Create.Object.S
