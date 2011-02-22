Filt
====

Description
-----------
はてブックマークの「お気に入り」ページの閾値反映版 RSS を配信

How to Use
----------

     # in Your Server
     git clone git://github.com/Cside/Filt.git
     cd Filt
     perl Makefile.PL
     ln -s atom.cgi /path/to/www/atom.cgi
     # and Edit config.ini

 * config.iniを書き換えて設定を行なってください.
 * atom.cgiにアクセスするとAtomフィードを吐いてくれます。
 * あとはLivedoor ReaderやGoogle Readerにwww/atom.cgiのURLを食わせればOKです。

Author
------
id:Cside (@Cside_)

