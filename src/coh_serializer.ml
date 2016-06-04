module type S =
sig
  include Coh_object.S
  (*
  val serialize : Coh_buf_writer.t -> 'a -> Coh_buf_writer.t
  val deserialize : Coh_buf_reader.t -> 'a
  *)
end

module I =
struct
  include Coh_object.Opaque
end

