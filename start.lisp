(ql:quickload "swank")
(ql:quickload "cl-ncurses")
(swank:create-server)
(ql:quickload "alexandria")

(load "slowly.lisp")
(setf *player* (make-instance 'player))

