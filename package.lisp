;;;; package.lisp

(defpackage #:slowly
  (:use :common-lisp 
        :cl-ncurses 
        :ccl 
        :alexandria)
  (:shadow :copy-file
           :false
           :true))


