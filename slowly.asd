;;;; slowly.asd

(asdf:defsystem #:slowly
  :serial t
  :description "A roguelike"
  :author "Davor Babic <davor@davor.se>"
  :license "BSD"
  :depends-on (#:cl-ncurses
               #:alexandria)
  :components ((:file "package")
               (:file "tiles")
               (:file "io")
               (:file "map")
               (:file "slowly")))
