# Makefile for COH*ML based on Makefile for OCI*ML

COH_HOME_CPP=$(HOME)/local/

OCAML_LIB=`opam config var lib`/ocaml

CCFLAGS=-ccopt -I$(OCAML_LIB) -ccopt -I$(COH_HOME_CPP)/include -ccopt -Wall -ccopt -Wno-permissive
COBJS=message.o messagemaplistener.o messageserializer.o cohml.o
MLOBJS=cohml.cmo log_message.cmo

OCAML_VERSION_MAJOR = `ocamlopt -version | cut -f1 -d.`
OCAML_VERSION_MINOR = `ocamlopt -version | cut -f2 -d.`
OCAML_VERSION_POINT = `ocamlopt -version | cut -f3 -d.`


all:	cohmlsh subscriber publisher message listener

cohmlsh:	$(COBJS) $(MLOBJS)
	ocamlmktop -custom -g -o $@ unix.cma $(MLOBJS) $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence
	mkdir -p log

subscriber:	$(COBJS) $(MLOBJS) subscriber.ml
	ocamlc -verbose -custom -g -annot -o $@ unix.cma $(MLOBJS) subscriber.ml $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence

publisher:	$(COBJS) $(MLOBJS) publisher.ml
	ocamlc -verbose -g -annot -custom -o $@ unix.cma $(MLOBJS) publisher.ml $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence

message:	$(COBJS) $(MLOBJS) message.ml
	ocamlc -verbose -g -custom -o $@ unix.cma $(MLOBJS) message.ml $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence


listener:	$(COBJS) $(MLOBJS) listener.ml
	ocamlc -verbose -g -annot -custom -o $@ unix.cma $(MLOBJS) listener.ml $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence

%.o:	%.c
	ocamlc -verbose -custom -ccopt -xc++ -ccopt -g3 -c -o $@ -ccopt -fpermissive -ccopt -I$(COH_HOME_CPP)/include $< -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence -ccopt -DOCAML_VERSION_MINOR=$(OCAML_VERSION_MINOR)

%.cmo: %.ml
	ocamlc -verbose -custom -c -g -annot unix.cma %.o $<

clean:
	rm -f *.o *.cm* *.so *.a cohmlsh listener message subscriber publisher *~

# End of file
