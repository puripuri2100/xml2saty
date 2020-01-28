PREFIX=/usr/local
TARGET=xml2saty
BINDIR=$(PREFIX)/bin
BUILD=_build


.PHONY: build install uninstall clean example

build: src
	-mkdir ${BUILD}
	cp src/lex.mll ${BUILD}
	cp src/parse.mly ${BUILD}
	cp src/*.ml src/*.mli ${BUILD}
	cd ${BUILD} && ocamllex lex.mll
	cd ${BUILD} && menhir parse.mly
	cd ${BUILD} && ocamlfind ocamlopt -o xml2saty -linkpkg -package xml-light range.ml error.mli error.ml types.ml parse.mli parse.ml lex.ml optionState.mli optionState.ml satysfiSyntax.mli satysfiSyntax.ml configState.mli configState.ml configApply.mli configApply.ml main.ml
	cp ${BUILD}/${TARGET} ./

install: ${TARGET}
	mkdir -p $(BINDIR)
	install $(TARGET) $(BINDIR)

uninstall:
	rm -rf $(BINDIR)/$(TARGET)

test: src xml2saty
	./xml2saty -o test.saty -c test.x2s-config -t "<a> <b>1A</b> <c>3A<b>2A<c>3B</c></b></c> </a>"
	./xml2saty test2.xml -c test.x2s-config
	./xml2saty t/test3.xml -o t/test3.saty -c test.x2s-config

example: src example/law.x2s-config
	./xml2saty -f example/gengou.xml -o example/gengou.saty -c example/law.x2s-config
	./xml2saty -f example/keihou.xml -o example/keihou.saty -c example/law.x2s-config


clean:
	@rm -rf *.cmi *.cmx *.cmo *.o *.out ${BUILD} ${TARGET} example/*.pdf example/*.satysfi-aux example/*.saty