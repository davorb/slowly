; (asdf:oos 'asdf:load-op :swank)
; (swank:create-server)
; alexandria (switch)

(in-package #:slowly)

(defclass player ()
  ((x-pos  :initform 2 
           :accessor x-pos)
   (y-pos  :initform 5
           :accessor y-pos)
   (health :initform 100
           :accessor health)
   (symbol :initform "@"
           :accessor symbol)
   (name   :initform "Player"
           :accessor name)))
(setf *player* (make-instance 'player))

(defclass map ()
  ((width  :accessor width)
   (height :accessor height)
   (data)))

(defun game ()
  (init-graphics)
  (let ((player (make-instance 'player))
        (map (make-instance 'map)))
    (game-loop player map)))

(defun game-loop (player map)
  (do () ()
    (let ((key (read-key)))
      (cl-ncurses:erase)
      (handle-input key player)
      (draw-gui player)
      (draw-player player)
;      (draw-map map)

      (cl-ncurses:refresh)
      (cl-ncurses:move 0 0))))

(defun move-up (player)
  (decf (x-pos player)))

(defun move-down (player)
  (incf (x-pos player)))

(defun move-right (player)
  (incf (y-pos player)))

(defun move-left (player)
  (decf (y-pos player)))

(defun handle-input (input player)
  (alexandria:switch (input :test eql)
    (65 (move-up player))
    (66 (move-down player))
    (68 (move-left player))
    (67 (move-right player))

    (otherwise (print-status (concatenate 'string "input: " (write-to-string input))))))
