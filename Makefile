compile: main.ml error.ml error.mli optionState.ml optionState.mli satysfiSyntax.ml satysfiSyntax.mli types.ml configState.ml configState.mli configApply.ml configApply.mli
	-mkdir _build
	cp lex.mll _build
	cp parse.mly _build
	cp main.ml error.ml error.mli optionState.ml optionState.mli satysfiSyntax.ml satysfiSyntax.mli types.ml configState.ml configState.mli configApply.ml configApply.mli _build
	cd _build && ocamllex lex.mll
	cd _build && menhir parse.mly
	cd _build && ocamlfind ocamlopt -o xml2saty -linkpkg -package xml-light,str types.ml parse.mli parse.ml lex.ml error.mli error.ml optionState.mli optionState.ml satysfiSyntax.mli satysfiSyntax.ml configState.mli configState.ml configApply.mli configApply.ml main.ml
	cp _build/xml2saty ./

test: main.ml error.ml error.mli optionState.ml optionState.mli satysfiSyntax.ml satysfiSyntax.mli types.ml configState.ml configState.mli configApply.ml configApply.mli xml2saty
	./xml2saty -o test.saty -c test.x2s-config -t "<a> <b>1A</b> <c>3A<b>2A<c>3B</c></b></c> </a>"
	./xml2saty test2.xml -c test.x2s-config
	./xml2saty t/test3.xml -o t/test3.saty -c test.x2s-config

law: main.ml error.ml error.mli optionState.ml optionState.mli satysfiSyntax.ml satysfiSyntax.mli types.ml configState.ml configState.mli configApply.ml configApply.mli xml2saty
	./xml2saty -o t/gengou.saty -f t/354AC0000000043_20150801_000000000000000.xml -c test.x2s-config
	./xml2saty -o t/keihou.saty -f t/140AC0000000045_20170713_429AC0000000072.xml -c test.x2s-config


.PHONY: clean

clean:
	@rm -rf *.cmi *.cmx *.cmo *.o *.out _build xml2saty