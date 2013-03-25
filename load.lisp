(ql:quickload "swank")
;(ql:quickload "cl-ncurses")
(swank:create-server)
;(ql:quickload "alexandria")

;; (defpackage :se.davor.slowly
;;   (:use :common-lisp 
;;         :cl-ncurses 
;;         :ccl 
;;         :alexandria)
;;   (:shadow :copy-file
;;            :false
;;            :true))

;; (load "io.lisp")
;; (load "slowly.lisp")

(asdf:load-system 'slowly)
(write-line "Ok!")
;(quit)
