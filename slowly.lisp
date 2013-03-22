; (asdf:oos 'asdf:load-op :swank)
; (swank:create-server)
; alexandria (switch)

(defmacro draw (string line inset)
  `(progn
    (with-cstrs ((s ,string))
      (cl-ncurses:mvaddstr ,line ,inset s))))

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

(defun game ()
  (init-graphics)
  (let ((player (make-instance 'player)))
    (game-loop player)))

(defun handle-input (input player)
  (alexandria:switch (input :test string=)
    ("65" (move-up player))
    ("66" (move-down player))
    ("68" (move-left player))
    ("67" (move-right player))
    (otherwise (print-status (concatenate 'string "input: " (write-to-string input))))))

(defun game-loop (player)
  (do () ()
    (let ((key (write-to-string (cl-ncurses:getch))))
      (handle-input key player)
      (draw-screen player)
      (cl-ncurses:move 0 0))))

(defun move-up (player)
  (decf (x-pos player)))

(defun move-down (player)
  (incf (x-pos player)))

(defun move-right (player)
  (incf (y-pos player)))

(defun move-left (player)
  (decf (y-pos player)))

(defun draw-screen (player)
  (cl-ncurses:erase)
  (draw-sidebar player)
  (draw-player player)
  (cl-ncurses:refresh))

(defun print-status (message)
  (let ((window-height (1- (cl-ncurses:getmaxy cl-ncurses:*stdscr*))))
    (draw message window-height 1)
    (cl-ncurses:refresh)))

(defun draw-sidebar (player)
  (let ((window-width (- (cl-ncurses:getmaxx cl-ncurses:*stdscr*) 13)))
    (draw (concatenate 'string "Health: " 
                       (write-to-string (health player))) 0 window-width)
    (draw "Hunger: 10%" 1 window-width)
    (draw "-----------" 2 window-width)
    (with-color :green
      (draw (concatenate 'string 
                         (symbol player)
                         " "
                         (name player)) 3 window-width))
    (with-color :red
      (draw "nope" 4 window-width))
    (cl-ncurses:refresh)))

(defun draw-player (player)
  (with-color :red
    (draw "@" (x-pos player) (y-pos player))))

;; (defun update-player-pos (input player)
;;   (case input
;;     (27 '(decf (x-pos player)))
;;     (otherwise )

(defun init-graphics ()
  (cl-ncurses:initscr)
  (write-line (concatenate 'string "has colors: " (write-to-string (= 1 (cl-ncurses:has-colors)))))
  (cl-ncurses:start-color)
  (cl-ncurses:curs-set 0)
  (cl-ncurses:nonl)
  (cl-ncurses:noecho)
  (cl-ncurses:cbreak)
  (cl-ncurses:clear)
  (cl-ncurses:refresh)
  (cl-ncurses:init-pair 1 cl-ncurses:COLOR_WHITE cl-ncurses:COLOR_BLACK)
  (cl-ncurses:init-pair 2 cl-ncurses:COLOR_RED cl-ncurses:COLOR_BLACK)
  (cl-ncurses:init-pair 3 cl-ncurses:COLOR_GREEN cl-ncurses:COLOR_BLACK)
  (cl-ncurses:init-pair 4 cl-ncurses:COLOR_BLUE cl-ncurses:COLOR_BLACK)
  (cl-ncurses:init-pair 4 cl-ncurses:COLOR_BLACK cl-ncurses:COLOR_WHITE))

(defmacro printw (text)
  `(with-cstrs ((s ,text))
     (cl-ncurses:printw s)
     (cl-ncurses:refresh)))

(defmacro with-color (color &body body)
  (let ((color-value
         (case color-sym
           (:red '2)
           (:green '3)
           (:blue '4)
           (:black-on-white '5)
           (otherwise '1))))
    `(progn
       (cl-ncurses:attron (cl-ncurses:COLOR-PAIR ,color-value))
       ,@body
       (cl-ncurses:attron (cl-ncurses:COLOR-PAIR 1)))))
