
# はじめに

XMLファイルをSATySFiのsatyファイルに変換するソフトウェアを作成しました。

名前はやや安直で、"xml2saty"です。リポジトリは[ここ](https://github.com/puripuri2100/xml2saty)にあります。

# インストール

- OPAMをインストールします
```
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```
で入ります。
- OCamlをインストールします
```
opam init --comp 4.07.0

eval $(opam env)
```
などとすると良いでしょう（Ubuntu on WSLえを使っている人は`opam init`の際に`--disable-sandboxing`というオプションをつけてください）。
バージョンは古すぎなければ大体のもので動くと思われます。
- 依存ライブラリをインストールする
```
opam install xml-light
opam install menhir
```
でインストールできます。既に入っている場合はしなくて大丈夫です。
- リポジトリをクローンしてビルドする
```
git clone https://github.com/puripuri2100/xml2saty.git
cd xml2saty
make build
```
でビルドができ、フォルダに`xml2saty`という名前の実行ファイルができます。

後は適当にフォルダに移動させるなりしてパスを適切に設定してください。

# 使い方

`-f`もしくは`--file`オプションでXMLファイルを渡すことができます。このオプションは省略することができます。

`-o`または`--output`オプションで出力ファイル名を指定できます。無い場合は入力のファイル名を流用します。オプションそのものを省略するとXMLファイルの名前から自動的にファイルが作成されます。

`-c`または`--config`で設定ファイルを渡すことができます。オプションそのものを省略するとXMLファイルの名前から自動的に設定ファイルが探されます。

`-t`または`--text`で直接XML文字列を渡すことができます。このとき、`-o`・`--output`・`-c`・`--config`オプションは省略できません。

起動は

```
xml2saty -f 〈XMLファイル〉 -o 〈satyファイル〉 -c 〈設定ファイル〉
```

です。

## 入力するXMLファイルについて

xml-lightパッケージが処理できる正しいXMLファイルである必要があります。

また、要素の名前などについてはASCII文字以外である場合の動作については保証できません。

また、ファイル名を渡すときに拡張子は省略できません。

## 出力ファイルについて

`-o`や`--output`オプションに渡すファイル名では拡張子を省略できません。

## 設定ファイルについて

設定ファイルの拡張子は`.x2s-config`で、文法はオリジナルのものです。

```
require [stdja; list]
```

のように

```
〈設定タグ〉 [〈リスト〉]
```

のように記述します。リストの区切りはセミコロンです。また、リスト内で使える文字列は以下の文字列を含まないものです。
- 設定タグで使われている単語3つ
- SATySFiの型名
- 括弧
- セミコロン
- コンマ
- アスタリスク
- ダブルクオーテーション

設定タグは

- `require`：`@require:`の後に記述されるパッケージ名（パス）をリストの形で書きます。
- `import`：`@import:`の後に記述されるパッケージの相対パスをリストの形で書きます。
- `attrib`：要素の属性の変換方法ついて指定をします。これだけは`〈要素名〉(〈要素の中身の型（省略可）〉)[〈(〈属性名〉,〈SATySFiの型名〉,〈その属性がコマンドの何番目の引数か〉)のリスト〉]`のリストになります。ややこしいですが、例えば
```
attrib
  [
    Paragraph (block-text)[
      (Hide, bool, 2);
      (Num, int, 1)
    ];
    ParagraphNum(inline-text)[];
    ParagraphCaption(inline-text)[];
    ParagraphSentence(inline-text)[];
    Sentence (inline-text) [
      (WritingMode, string, 1);
    ];
  ]
```
みたいな感じです。
このとき、属性のリストに含まれなかった属性は無視されます。

これらを与えることで出力されるファイルの中身を制御できるようになります。


使える型名は現在のところ

- `string`
- `int`
- `bool`
- `float`
- `length`
- `inline-text`
- `block-text`
- `funciton`
- `<type> list`

です。`function`を選択すると、要素の中にある子要素が全て関数扱いになり、先頭が小文字になります。
`inline-text`は先頭に`\`が付き、`block-text`は`+`が付きます。
`inline-text list`のように`<type> list`のように書くことでリストの形でも出力できます。




# 使用例

リポジトリにexampleフォルダの中にe-Gov法令検索からダウンロードできる元号法と刑法のXMLファイルが置いてあります。

```
make example
```

でsatyファイルを作成することができます。

付属の`local.satyh`にコマンドの定義が書いてあるのでそれを使って
```
satysfi example/keihou.saty -o example/keihou.pdf
```
のようにしてコンパイルすることができます。

また、これを応用することによりHTMLファイルをsatyファイルに変換することも可能なはずです。