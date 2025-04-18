#!/bin/bash

# zenityを使用してGUIで確認メッセージを表示
if ! zenity --question --text="ダウンロードフォルダ内のファイルとフォルダを削除しますか？"; then
    exit 0
fi

# ダウンロードフォルダのパス（必要に応じて変更）
DOWNLOAD_DIR="$HOME/ダウンロード"

# フォルダが存在するか確認
if [ ! -d "$DOWNLOAD_DIR" ]; then
    zenity --error --text="ダウンロードフォルダが見つかりません: $DOWNLOAD_DIR"
    exit 1
fi

# ダウンロードフォルダ内にファイルやフォルダが存在するか確認
if [ -z "$(find "$DOWNLOAD_DIR" -mindepth 1)" ]; then
    zenity --info --text="ダウンロードフォルダは既に空です。"
    exit 0
fi

# gioが使用可能か確認
if ! command -v gio &> /dev/null; then
    zenity --error --text="gioコマンドが見つかりません。"
    exit 1
fi

# ファイル・ディレクトリをまとめてゴミ箱に移動
gio trash "$DOWNLOAD_DIR"/* "$DOWNLOAD_DIR"/.*

# 見落としがちな隠しファイルを除いた残りの確認
REMAINING=$(find "$DOWNLOAD_DIR" -mindepth 1)
if [ -n "$REMAINING" ]; then
    zenity --warning --text="一部のファイルやフォルダを削除できませんでした。"
else
    zenity --info --text="すべてのファイルとフォルダがゴミ箱に移動されました。"
fi
# 