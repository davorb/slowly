(in-package #:slowly)

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
       (attron (COLOR-PAIR ,color-value))
       ,@body
       (attron (COLOR-PAIR 1)))))

(defmacro draw (string line inset)
  `(progn
    (with-cstrs ((s ,string))
      (mvaddstr ,line ,inset s))))

(defmacro output-string (string)
  `(progn
     (with-cstrs ((s ,string))
       (printw s))))

(defun get-char ()
  (getch))

(defun draw-map (map)
  (draw "map!" 5 5))

(defun print-status (message)
  (draw message 0 1)
  (cl-ncurses:refresh))

(defvar *sidebar-width* 10)
(defun draw-gui (player)
  (let* ((window-height (1- (cl-ncurses:getmaxy cl-ncurses:*stdscr*)))
         (window-width (cl-ncurses:getmaxx cl-ncurses:*stdscr*)))
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
      (draw " | Level: 12" window-height 27))))

(defun draw-player (player)
  (with-color :red
    (draw (symbol player) (x-pos player) (y-pos player))))

(defun read-key ()
  (let ((key (get-char)))
    (if (= 27 key)
        (progn
          (get-char)
          (get-char))
        (identity key))))

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
