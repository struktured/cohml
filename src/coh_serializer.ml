module type S =
sig
  include Coh_object.S
  (*
  val serialize : Coh_buf_writer.t -> 'a -> Coh_buf_writer.t
  val deserialize : Coh_buf_reader.t -> 'a
  *)
end

include Coh_object.Make(struct type t let name = "Serializer" end)

