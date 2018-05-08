# このソフトウェアについて

確認用の関数。`read`コマンドを使う。

# 使い方

1. 関数呼出  
```sh
. Confirm.sh
Confirm yN- 質問文 "echo YES!!" "echo NO..."
```
2. 表示  
```sh
質問文 (y/N): 
```
3. 選択後  
```sh
質問文 (y/N): y
YES!!
```

* 詳細は[memo/confirm.md](memo/confirm.md)参照

# 開発環境

* [Raspberry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 3 Model B
    * [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) GNU/Linux 8.0 (jessie)
        * bash 4.3.30

# ライセンス

このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)
