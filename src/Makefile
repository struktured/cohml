COH_HOME_CPP=$(HOME)/local/

OCAML_LIB=`opam config var lib`/ocaml

CCFLAGS=-ccopt -I$(OCAML_LIB) -ccopt -I$(COH_HOME_CPP)/include -ccopt -Wall -ccopt -Wno-permissive
COBJS=pof_writer.o pof_reader.o pof_context.o cohml.o
MLOBJS=pof_writer.cmo pof_reader.cmo pof_context.cmo cohml.cmo

OCAML_VERSION_MAJOR = `ocamlopt -version | cut -f1 -d.`
OCAML_VERSION_MINOR = `ocamlopt -version | cut -f2 -d.`
OCAML_VERSION_POINT = `ocamlopt -version | cut -f3 -d.`


all:	cohml

cohml:	$(COBJS) $(MLOBJS)
	ocamlmklib -custom -g -o $@ unix.cma $(MLOBJS) $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence
	mkdir -p log

%.o:	%.c
	ocamlc -verbose -custom -ccopt -xc++ -ccopt -g3 -c -o $@ -ccopt -fpermissive -ccopt -I$(COH_HOME_CPP)/include $< -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence -ccopt -DOCAML_VERSION_MINOR=$(OCAML_VERSION_MINOR)

%.cmo: %.ml
	ocamlc -verbose -custom -c -g -annot unix.cma %.o $<

clean:
	rm -f *.o *.cm* *.so *.a cohmlsh cohml *~

# End of file
