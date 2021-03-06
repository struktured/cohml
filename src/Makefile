ifndef COH_HOME_CPP
  COH_HOME_CPP=/opt/coherence-cpp
endif

ifndef OCAML_LIB
  OCAML_LIB=`opam config var lib`/ocaml
endif

CCFLAGS=-ccopt -I$(OCAML_LIB) -ccopt -I$(COH_HOME_CPP)/include -ccopt -Wall -ccopt -Wno-permissive
COBJS=pof_writer.o pof_reader.o pof_serializer.o pof_context.o coh_map.o cohml.o

MLOBJS=coh_primitives.cmo coh_object.cmo coh_class.cmo coh_comparator.cmo coh_primitive.cmo coh_boolean.cmo coh_array.cmo coh_binary.cmo \
       coh_iterator.cmo coh_collection.cmo coh_set.cmo coh_list.cmo coh_entry.cmo coh_map.cmo coh_entry_processor.cmo coh_serializer.cmo \
       pof_context.cmo pof_writer.cmo pof_reader.cmo pofable.cmo coh_pof_iterator.cmo coh_pof_entry.cmo pof_serializer.cmo \
       coh_filter.cmo coh_value_extractor.cmo coh_pofable_map.cmo coh_query_map.cmo coh_observable_map.cmo coh_map_event.cmo \
       coh_map_listener.cmo coh_invocable_map.cmo coh_named_cache.cmo cohml.cmo

MLPACKAGES = ctypes,ctypes.foreign

OCAML_VERSION_MAJOR = `ocamlopt -version | cut -f1 -d.`
OCAML_VERSION_MINOR = `ocamlopt -version | cut -f2 -d.`
OCAML_VERSION_POINT = `ocamlopt -version | cut -f3 -d.`


all:	cohml

cohml:	$(COBJS) $(MLOBJS)
	ocamlfind ocamlmklib -custom -g -o $@ unix.cma $(MLOBJS) -package $(MLPACKAGES) $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence
	mkdir -p log

%.o:	%.c
	ocamlfind ocamlc -verbose -custom -ccopt -xc++ -ccopt -g3 -c -o $@ -ccopt -fpermissive -ccopt -I$(COH_HOME_CPP)/include $< -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence -ccopt -DOCAML_VERSION_MINOR=$(OCAML_VERSION_MINOR)

%.cmo: %.ml
	ocamlfind ocamlc -package $(MLPACKAGES) -verbose -custom -c -g -annot unix.cma %.o $<

clean:
	rm -f *.o *.cm* *.so *.a cohmlsh cohml *~

# End of file
