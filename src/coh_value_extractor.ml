module type S =
sig
  include Coh_object.S
end

module I = Coh_object.Opaque

