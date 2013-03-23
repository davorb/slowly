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

(defclass map ()
  ((width  :accessor width)
   (height :accessor height)
   (data)))

(defun game ()
  (init-graphics)
  (let ((player (make-instance 'player))
        (map (make-instance 'map)))
    (game-loop player map)))

(defun handle-input (input player)
  (alexandria:switch (input :test string=)
    ("65" (move-up player))
    ("66" (move-down player))
    ("68" (move-left player))
    ("67" (move-right player))
    (otherwise (print-status (concatenate 'string "input: " (write-to-string input))))))

(defun game-loop (player map)
  (do () ()
    (let ((key (write-to-string (cl-ncurses:getch))))
      (handle-input key player)
      (cl-ncurses:erase)
      (draw-map map)
      (draw-gui player)
      (draw-player player)

      (cl-ncurses:refresh))
      (cl-ncurses:move 0 0))))

(defun draw-map (map)
  (draw "map!" 5 5))

(defun move-up (player)
  (decf (x-pos player)))

(defun move-down (player)
  (incf (x-pos player)))

(defun move-right (player)
  (incf (y-pos player)))

(defun move-left (player)
  (decf (y-pos player)))

(defun print-status (message)
  (draw message 0 1)
  (cl-ncurses:refresh))

(defvar *sidebar-width* 10)
(defun draw-gui (player)
  (let* ((window-height (1- (cl-ncurses:getmaxy cl-ncurses:*stdscr*)))
         (window-width (cl-ncurses:getmaxx cl-ncurses:*stdscr*))
         (sidebar-inset (- window-width *sidebar-width*)))
    (with-color :white-on-blue
      ;; draw bar across the bottom of the window
      (let ((tmp ""))
        (dotimes (i window-width)
          (setf tmp (concatenate 'string tmp " ")))
        (draw tmp window-height 0))

      ;; items on the top bar
      (draw (concatenate 'string " Health: " 
                         (write-to-string (health player))) window-height 0)
      (draw " | Hunger: 100%" window-height 12)
      (draw " | Level: 12" window-height 27))

    #|
    (with-color :black-on-white
      ;; draw sidebar across the entire right side
      (dotimes (i (1- (cl-ncurses:getmaxy cl-ncurses:*stdscr*)))
        (let ((tmp ""))
          (dotimes (m *sidebar-width*)
            (setf tmp (concatenate 'string tmp " ")))
          (draw tmp i sidebar-inset))) 

      ;; sidebar items
      (draw " STR: 7" 0 sidebar-inset)
      (draw " DEX: 4" 1 sidebar-inset)

      (draw (concatenate 'string " "
                         (symbol player) " "
                         (name player)) 4 sidebar-inset))|#))

(defun draw-player (player)
  (with-color :red
    (draw (symbol player) (x-pos player) (y-pos player))))

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
  (cl-ncurses:init-pair 5 cl-ncurses:COLOR_BLACK cl-ncurses:COLOR_WHITE)
  (cl-ncurses:init-pair 6 cl-ncurses:COLOR_BLACK cl-ncurses:COLOR_BLUE)
  (cl-ncurses:init-pair 7 cl-ncurses:COLOR_WHITE cl-ncurses:COLOR_BLUE))

(defmacro with-color (color &body body)
  (let ((color-value
         (case color
           (:red '2)
           (:green '3)
           (:blue '4)
           (:black-on-white '5)
           (:black-on-blue '6)
           (:white-on-blue '7)
           (otherwise '1))))
    `(progn
       (cl-ncurses:attron (cl-ncurses:COLOR-PAIR ,color-value))
       ,@body
       (cl-ncurses:attron (cl-ncurses:COLOR-PAIR 1)))))
