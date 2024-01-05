# デザインパターンとは

## 目次

1. 概要
2. 良い設計とは
3. 設計原則
4. その他必要になる知識

## 概要

デザインパターンとはオブジェクト指向において、**よく出会う問題とそれに対処する良い設計**をパターン化し、カタログにしたもの<br>
GoF (Gang of Four)と呼ばれる 4 人の共著者によって執筆された書籍「オブジェクト指向における再利用のためのデザインパターン」で登場した<br>
デザインパターンを知ることで、経験が浅いプログラマでも先人たちの知恵を利用した良い設計をすることが出来る

> Design patterns solve specific design problems and make object-oriented designs more flexible, elegant, and ultimately reusable. They help designers reuse successful designs by basing new designs on prior experience. A designer who is familiar with such patterns can apply them immediately to design problems without having to rediscover them.

[wiki\_デザインパターン](<https://ja.wikipedia.org/wiki/%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3_(%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2)>)

## 良い設計とは？

オブジェクト指向の恩恵を最大限に得るための設計原則に則り、クラスやモジュール設計をすること<br>
オブジェクト指向の最大の恩恵は、コードをカプセル化することで、再利用性、拡張性に優れたコードが書けるところである

[テックスコア](https://www.techscore.com/tech/DesignPattern/foundation/foundation1#dp0-2)

### オブジェクト指向の設計思想

Alan Kay が Smalltalk というプログラミング言語を開発する中で生まれたプログラミングパラダイム<br>
状態(プロパティ)と振る舞い(メソッド)を隠蔽した再帰的な要素(コンポジションを持つオブジェクト)を作成し、それらがメッセージを通じて互いに対話する(メソッド呼び出し)ことで、大きなシステムを構築する<br>
状態と振る舞いを同じ要素に閉じ込めることで凝縮度を高め、メッセージというインターフェースを介し情報隠蔽性を高めることで、カプセル化することが目的だと思う<br>
これにより、プログラムの各部分は独立していながらも、一つの統合されたシステムとして機能するため、再利用性、拡張性に優れている<br>

> Smalltalk's design—and existence—is due to the insight that everything we can describe can be represented by the recursive composition of a single kind of behavioral building block that hides its combination of state and process inside itself and can be dealt with only through the exchange of messages.

[The Early History Of Smalltalk](http://worrydream.com/EarlyHistoryOfSmalltalk/)

## 設計原則

オブジェクト指向の恩恵を最大限に得るためのに守らなければならないルール<br>
デザインパターンはこのルールを守りながら設計する具体的な方法を提示してくれる

- SOLID
- DRY
- デルメルの法則

## その他必要になる知識

- 継承
- ポリモーフィズム
