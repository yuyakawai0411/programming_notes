require 'ripper'
require 'pp' # オブジェクトを見やすく表示するためのライブラリ

code = "5.0 + 4.0"
pp Ripper.sexp(code)

# 出力結果
# 左端の数字は行と列番号
# 2番目の要素はトークンの種類
# EXPR_ENDは式の終端を示す
# EXPR_BEGは式の開始を示す
=begin
[
 [[1, 0], :on_float, "5.0", EXPR_END],
 [[1, 3], :on_sp, " ", EXPR_END],
 [[1, 4], :on_op, "+", EXPR_BEG],
 [[1, 5], :on_sp, " ", EXPR_BEG],
 [[1, 6], :on_float, "4.0", EXPR_END]
]
=end

# [
#   :program, 
#   [
#     [
#       :binary,
#       [:@float, "5.0", [1, 0]],
#       :+,
#       [:@float, "4.0", [1, 6]]
#     ]
#   ]
# ]